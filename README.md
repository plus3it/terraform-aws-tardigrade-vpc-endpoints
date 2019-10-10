# terraform-aws-tardigrade-vpc-endpoints

Terraform module to create VPC Endpoints

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_vpc\_endpoints | toggle to create vpc endpoints | bool | `"true"` | no |
| subnet\_ids | target subnet ids | list(string) | `<list>` | no |
| tags | A map of tags to add to the VPC endpoint SG | map(string) | `<map>` | no |
| vpc\_endpoint\_services | List of aws endpoint service names that are used to create VPC Interface endpoints. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list. | list(string) | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_endpoint\_interface\_services |  |

