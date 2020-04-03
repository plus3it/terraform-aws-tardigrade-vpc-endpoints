data "aws_subnet" "selected" {
  count = var.create_vpc_endpoints ? 1 : 0

  id = var.subnet_ids[0]
}

data "aws_region" "selected" {}

data "aws_vpc_endpoint_service" "this" {
  for_each = toset(var.create_vpc_endpoints ? var.vpc_endpoint_services : [])

  // If we get a "common name" (like "kms") we must generate a fully qualified name.
  // If the name contains the current region we trust the user to have provided a valid fully qualified name.
  // This handles all _current_ services.
  // * Simple ones like "s3" or "sns".
  // * Complex common names like "ecr.dkr" and "ecr.api".
  // * Non-standard services like sagemeaker where the fully qualified name is like "aws.sagemaker.us-east-1.notebook".
  service_name = length(regexall(data.aws_region.selected.name, each.key)) == 1 ? each.key : "com.amazonaws.${data.aws_region.selected.name}.${each.key}"
}

data "aws_vpc" "selected" {
  count = var.create_vpc_endpoints ? 1 : 0

  id = local.vpc_id
}

locals {
  sg_egress_rules_default = list({
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  })
  sg_ingress_rules_default = list({
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.vpc_cidr]
  })
  vpc_id   = join("", data.aws_subnet.selected.*.vpc_id)
  vpc_cidr = join("", data.aws_vpc.selected.*.cidr_block)

  # Split Endpoints by their type
  gateway_endpoints = toset([for e in data.aws_vpc_endpoint_service.this : e.service_name if e.service_type == "Gateway"])
  interface_endpoints = toset([for e in data.aws_vpc_endpoint_service.this : e.service_name if e.service_type == "Interface"])

  # Only Interface Endpoints support SGs
  security_groups = toset(var.create_vpc_endpoints ? var.create_sg_per_endpoint ? local.interface_endpoints : ["shared"] : [])
}

resource "aws_security_group" "this" {
  for_each = local.security_groups

  description = var.create_sg_per_endpoint ? "VPC Interface ${each.key} Endpoint" : "VPC Interface Endpoints - Allow inbound from ${local.vpc_id} and allow all outbound"
  vpc_id      = local.vpc_id

  dynamic "egress" {
    for_each = var.sg_egress_rules != null ? var.sg_egress_rules : local.sg_egress_rules_default
    content {
      description      = lookup(egress.value, "description", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      from_port        = lookup(egress.value, "from_port", null)
      to_port          = lookup(egress.value, "to_port", null)
      protocol         = lookup(egress.value, "protocol", null)
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      security_groups  = lookup(egress.value, "security_groups", null)
    }
  }

  dynamic "ingress" {
    for_each = var.sg_ingress_rules != null ? var.sg_ingress_rules : local.sg_ingress_rules_default
    content {
      description      = lookup(ingress.value, "description", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      from_port        = lookup(ingress.value, "from_port", null)
      to_port          = lookup(ingress.value, "to_port", null)
      protocol         = lookup(ingress.value, "protocol", null)
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
    }
  }

  tags = var.tags
}

resource "aws_vpc_endpoint" "interface_services" {
  for_each = local.interface_endpoints

  vpc_id            = local.vpc_id
  service_name      = each.key
  vpc_endpoint_type = "Interface"
  auto_accept       = true

  subnet_ids = var.subnet_ids

  security_group_ids = var.create_sg_per_endpoint ? [aws_security_group.this[each.key].id] : [aws_security_group.this["shared"].id]

  private_dns_enabled = true # https://docs.aws.amazon.com/vpc/latest/userguide/vpce-interface.html#vpce-private-dns

  tags = var.tags
}

resource "aws_vpc_endpoint" "gateway_services" {
  for_each = local.gateway_endpoints

  vpc_id            = local.vpc_id
  service_name      = each.key
  vpc_endpoint_type = "Gateway"
  auto_accept       = true

  tags = var.tags
}
