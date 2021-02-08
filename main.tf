data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

data "aws_region" "selected" {}

data "aws_vpc_endpoint_service" "this" {
  for_each = { for service in var.vpc_endpoint_services : "${service.name}:${service.type}" => service }

  // If we get a "common name" (like "kms") we must generate a fully qualified name.
  // If the name contains the current region we trust the user to have provided a valid fully qualified name.
  // This handles all _current_ services.
  // * Simple ones like "s3" or "sns".
  // * Complex common names like "ecr.dkr" and "ecr.api".
  // * Non-standard services like sagemeaker where the fully qualified name is like "aws.sagemaker.us-east-1.notebook".
  service_name = length(regexall(data.aws_region.selected.name, each.value.name)) == 1 ? each.value.name : "com.amazonaws.${data.aws_region.selected.name}.${each.value.name}"
  service_type = title(each.value.type)
}

locals {
  vpc_id = data.aws_subnet.selected.vpc_id

  # Split Endpoints by their type
  gateway_endpoints   = toset([for e in data.aws_vpc_endpoint_service.this : e.service_name if e.service_type == "Gateway"])
  interface_endpoints = toset([for e in data.aws_vpc_endpoint_service.this : e.service_name if e.service_type == "Interface"])

  # Only Interface Endpoints support SGs
  security_groups = toset(
    length(local.interface_endpoints) > 0 ? (
      var.create_sg_per_endpoint ? local.interface_endpoints : ["shared"]
    ) : []
  )

  # Regex of Interface services that do not support Private DNS
  no_private_dns = "s3"
}

resource "aws_security_group" "this" {
  for_each = local.security_groups

  description = var.create_sg_per_endpoint ? "VPC Interface ${each.key} Endpoint" : "VPC Interface Endpoints"
  vpc_id      = local.vpc_id
  tags        = var.tags

  dynamic "egress" {
    for_each = var.sg_egress_rules
    content {
      description      = egress.value["description"]
      prefix_list_ids  = egress.value["prefix_list_ids"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
      security_groups  = egress.value["security_groups"]
    }
  }

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      description      = ingress.value["description"]
      prefix_list_ids  = ingress.value["prefix_list_ids"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
      security_groups  = ingress.value["security_groups"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "interface_services" {
  for_each = local.interface_endpoints

  auto_accept       = true
  service_name      = each.key
  tags              = var.tags
  vpc_endpoint_type = "Interface"
  vpc_id            = local.vpc_id

  subnet_ids = var.subnet_ids

  security_group_ids = var.create_sg_per_endpoint ? [aws_security_group.this[each.key].id] : [aws_security_group.this["shared"].id]

  # https://docs.aws.amazon.com/vpc/latest/userguide/vpce-interface.html#vpce-private-dns
  private_dns_enabled = length(regexall(local.no_private_dns, each.key)) == 0 ? true : false
}

resource "aws_vpc_endpoint" "gateway_services" {
  for_each = local.gateway_endpoints

  auto_accept       = true
  service_name      = each.key
  tags              = var.tags
  vpc_endpoint_type = "Gateway"
  vpc_id            = local.vpc_id
}
