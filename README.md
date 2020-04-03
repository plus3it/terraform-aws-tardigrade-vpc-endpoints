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
| sg\_egress\_rules | Egress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules. | `list` | n/a | yes |
| sg\_ingress\_rules | Ingress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules. | `list` | n/a | yes |
| create\_sg\_per\_endpoint | Toggle to create a SecurityGroup for each VPC Endpoint. Defaults to using just one for all Interface Endpoints. Note that Gateway Endpoints don't support SecurityGroups. | `bool` | `false` | no |
| create\_vpc\_endpoints | Toggle to create VPC Endpoints. | `bool` | `true` | no |
| subnet\_ids | Target Subnet ids. | `list(string)` | `[]` | no |
| tags | A map of tags to add to the VPC Endpoint and to the SecurityGroup(s). | `map(string)` | `{}` | no |
| vpc\_endpoint\_services | List of AWS Endpoint service names that are used to create VPC Interface Endpoints. Both Gateway and Interface Endpoints are supported. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_endpoint\_interface\_services | n/a |
| vpc\_endpoint\_gateway\_services | n/a |
| vpc\_endpoint\_sgs | n/a |

<!-- END TFDOCS -->
