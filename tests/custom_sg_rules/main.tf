provider "aws" {
  region = "us-east-1"
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v2.70.0"

  name                 = "tardigrade-vpc-endpoints-${random_string.this.result}"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

locals {
  sg_ingress_rules = [
    {
      description     = null
      prefix_list_ids = null
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks = [
        module.vpc.vpc_cidr_block,
        "10.11.22.0/24"
      ]
      ipv6_cidr_blocks = null
      security_groups  = null
    }
  ]
}

module "custom_sg_rules" {
  source = "../../"

  vpc_endpoint_services = [
    {
      name = "config"
      type = "Interface"
    },
  ]

  subnet_ids       = module.vpc.private_subnets
  sg_ingress_rules = local.sg_ingress_rules
}
