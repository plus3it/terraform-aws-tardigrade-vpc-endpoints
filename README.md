# terraform-aws-tardigrade-vpc-endpoints

Terraform module to create VPC Endpoints

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_vpc\_endpoints | toggle to create vpc endpoints | string | `"false"` | no |
| subnet\_ids | target subnet ids | list | `<list>` | no |
| tags | A map of tags to add to the VPC endpoint SG | map | `<map>` | no |
| vpc\_endpoint\_interfaces | List of aws api endpoints that are used to create VPC Interface endpoints. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list. | list | `<list>` | no |

