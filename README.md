# terraform-aws-tardigrade-vpc-endpoints

Terraform module to create VPC Endpoints

## Default Security Group rules
Please be aware that the default Security Groups attached to Endpoints allow Ingress and Egress from anywhere
(`0.0.0.0/0`). It is advised that users adjust these to fit their desired security posture. We recommend a minimum
of restricting Ingress to the VPC `cidr_block`.

## Terraform version requirements
Terraform `>= 0.12.9` is required due to a bug fix related to empty sets with `for_each`. The fix was included in
version `0.12.9` -- see the [Changelog here](https://github.com/hashicorp/terraform/blob/v0.12/CHANGELOG.md#0129-september-17-2019).
The original [bug was reported as issue #22281](https://github.com/hashicorp/terraform/issues/22281).

## Updating documentation
Portions of this module's README.md, and those in its `tests` directory, are generated automatically. To update the sections inside `BEGIN TFDOCS` and `END TFDOCS` run the following:

```sh
## This will run terraform-docs in the docker container, which of
## course requires that you have docker...
# The 'init' target is a one time task... it simply clones a "ci" repository to access shared make targets
make init
make docker/run target=docs/generate

## Or
## This will install terraform-docs to your local system, may not
## be desirable for you. And may not work if the make target does
## not account for your OS
make docs/generate
```

Then commit the updated files.

## Testing

Manual testing:

```
# Replace "xxx" with an actual AWS profile, then execute the integration tests.
export AWS_PROFILE=xxx 
make terraform/pytest PYTEST_ARGS="-v --nomock"
```

For automated testing, PYTEST_ARGS is optional and no profile is needed:

```
make mockstack/up
make terraform/pytest PYTEST_ARGS="-v"
make mockstack/clean
```

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_region.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route_table.gateway_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc_endpoint_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Target Subnet IDs for "Interface" services. Also used to resolve the `vpc_id` and route\_table\_ids for "Gateway" services | `list(string)` | n/a | yes |
| <a name="input_vpc_endpoint_services"></a> [vpc\_endpoint\_services](#input\_vpc\_endpoint\_services) | List of AWS Endpoint service names and types. Both Gateway and Interface Endpoints are supported. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list. | <pre>list(object({<br>    name = string<br>    type = string<br>  }))</pre> | n/a | yes |
| <a name="input_create_sg_per_endpoint"></a> [create\_sg\_per\_endpoint](#input\_create\_sg\_per\_endpoint) | Toggle to create a SecurityGroup for each VPC Endpoint. Defaults to using just one for all Interface Endpoints. Note that Gateway Endpoints don't support SecurityGroups. | `bool` | `false` | no |
| <a name="input_sg_egress_rules"></a> [sg\_egress\_rules](#input\_sg\_egress\_rules) | Egress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules. | <pre>list(object({<br>    description      = string<br>    prefix_list_ids  = list(string)<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>    security_groups  = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": null,<br>    "from_port": 0,<br>    "ipv6_cidr_blocks": null,<br>    "prefix_list_ids": null,<br>    "protocol": "-1",<br>    "security_groups": null,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_sg_ingress_rules"></a> [sg\_ingress\_rules](#input\_sg\_ingress\_rules) | Ingress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules. | <pre>list(object({<br>    description      = string<br>    prefix_list_ids  = list(string)<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>    security_groups  = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": null,<br>    "from_port": 0,<br>    "ipv6_cidr_blocks": null,<br>    "prefix_list_ids": null,<br>    "protocol": "-1",<br>    "security_groups": null,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the VPC Endpoint and to the SecurityGroup(s). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_endpoint_gateway_services"></a> [vpc\_endpoint\_gateway\_services](#output\_vpc\_endpoint\_gateway\_services) | n/a |
| <a name="output_vpc_endpoint_interface_services"></a> [vpc\_endpoint\_interface\_services](#output\_vpc\_endpoint\_interface\_services) | n/a |
| <a name="output_vpc_endpoint_sgs"></a> [vpc\_endpoint\_sgs](#output\_vpc\_endpoint\_sgs) | n/a |

<!-- END TFDOCS -->
