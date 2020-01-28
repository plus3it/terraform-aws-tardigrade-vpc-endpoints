# terraform-aws-tardigrade-vpc-endpoints

Terraform module to create VPC Endpoints


<!-- BEGIN TFDOCS -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| sg\_egress\_rules | Egress rules for the vpc endpoint sg(s). Set to empty list to disable default rules. | `list` | n/a | yes |
| sg\_ingress\_rules | Ingress rules for the vpc endpoint sg(s). Set to empty list to disable default rules. | `list` | n/a | yes |
| create\_sg\_per\_endpoint | toggle to create a sg for each vpc endpoint. Defaults to using just one for all endpoints. | `bool` | `false` | no |
| create\_vpc\_endpoints | toggle to create vpc endpoints | `bool` | `true` | no |
| subnet\_ids | target subnet ids | `list(string)` | `[]` | no |
| tags | A map of tags to add to the VPC endpoint SG | `map(string)` | `{}` | no |
| vpc\_endpoint\_services | List of aws endpoint service names that are used to create VPC Interface endpoints. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_endpoint\_interface\_services | n/a |
| vpc\_endpoint\_sgs | n/a |

<!-- END TFDOCS -->
