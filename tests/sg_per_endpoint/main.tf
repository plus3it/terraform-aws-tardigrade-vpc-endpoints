resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v6.0.1"

  name                 = "tardigrade-vpc-endpoints-${random_string.this.result}"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "sg_per_endpoint" {
  source = "../../"

  vpc_endpoint_services = [
    {
      name = "s3"
      type = "Gateway"
    },
    {
      name = "s3"
      type = "Interface"
    },
    {
      name = "sns"
      type = "Interface"
    },
  ]

  subnet_ids             = module.vpc.private_subnets
  create_sg_per_endpoint = true
}
