provider aws {
  region = "us-east-1"
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v2.15.0"
  providers = {
    aws = aws
  }

  name                 = "tardigrade-vpc-endpoints-${random_string.this.result}"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "gateway_type_endpoint" {
  source = "../../"
  providers = {
    aws = aws
  }

  create_vpc_endpoints  = true
  vpc_endpoint_services = ["s3"]
  subnet_ids            = module.vpc.private_subnets
}
