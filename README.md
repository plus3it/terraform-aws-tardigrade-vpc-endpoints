# terraform-aws-tardigrade-vpc-endpoints

Terraform module to create VPC Endpoints

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_sg\_per\_endpoint | toggle to create a sg for each vpc endpoint. Defaults to using just one for all endpoints. | bool | `"false"` | no |
| create\_vpc\_endpoints | toggle to create vpc endpoints | bool | `"true"` | no |
| sg\_egress\_rules | Egress rules for the vpc endpoint sg\(s\). Set to empty list to disable default rules. | list | `"null"` | no |
| sg\_ingress\_rules | Ingress rules for the vpc endpoint sg\(s\). Set to empty list to disable default rules. | list | `"null"` | no |
| subnet\_ids | target subnet ids | list(string) | `<list>` | no |
| tags | A map of tags to add to the VPC endpoint SG | map(string) | `<map>` | no |
| vpc\_endpoint\_services | List of aws endpoint service names that are used to create VPC Interface endpoints. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list. | list(string) | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_endpoint\_interface\_services |  |
| vpc\_endpoint\_sgs |  |

