data "aws_subnet" "selected" {
  count = "${var.create_vpc_endpoints ? 1 : 0}"

  id = "${var.subnet_ids[0]}"
}

data "aws_vpc" "selected" {
  count = "${var.create_vpc_endpoints ? 1 : 0}"

  id = "${local.vpc_id}"
}

locals {
  vpc_id   = "${join("", data.aws_subnet.selected.*.vpc_id)}"
  vpc_cidr = "${join("", data.aws_vpc.selected.*.cidr_block)}"
}

resource "aws_security_group" "this" {
  count = "${var.create_vpc_endpoints ? 1 : 0}"

  description = "VPC Interface Endpoints - Allow inbound from ${local.vpc_id} and allow all outbound"
  vpc_id      = "${local.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.tags}"
}

resource "aws_vpc_endpoint" "interface_services" {
  count = "${var.create_vpc_endpoints ? length(var.vpc_endpoint_interfaces) : 0}"

  vpc_id            = "${local.vpc_id}"
  service_name      = "${var.vpc_endpoint_interfaces[count.index]}"
  vpc_endpoint_type = "Interface"
  auto_accept       = true

  subnet_ids = [
    "${var.subnet_ids}",
  ]

  security_group_ids = [
    "${aws_security_group.this.id}",
  ]

  private_dns_enabled = true # https://docs.aws.amazon.com/vpc/latest/userguide/vpce-interface.html#vpce-private-dns
}
