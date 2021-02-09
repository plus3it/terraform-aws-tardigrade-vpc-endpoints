variable "create_sg_per_endpoint" {
  description = "Toggle to create a SecurityGroup for each VPC Endpoint. Defaults to using just one for all Interface Endpoints. Note that Gateway Endpoints don't support SecurityGroups."
  type        = bool
  default     = false
}

variable "sg_egress_rules" {
  description = "Egress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules."
  type = list(object({
    description      = string
    prefix_list_ids  = list(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
  }))
  default = [{
    description      = null
    prefix_list_ids  = null
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
  }]
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules."
  type = list(object({
    description      = string
    prefix_list_ids  = list(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
  }))
  default = [{
    description      = null
    prefix_list_ids  = null
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
  }]
}

variable "subnet_ids" {
  description = "Target Subnet IDs for \"Interface\" services. Also used to resolve the `vpc_id` for \"Gateway\" services"
  type        = list(string)
}

variable "vpc_endpoint_services" {
  description = "List of AWS Endpoint service names and types. Both Gateway and Interface Endpoints are supported. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list."
  type = list(object({
    name = string
    type = string
  }))
}

variable "tags" {
  description = "A map of tags to add to the VPC Endpoint and to the SecurityGroup(s)."
  type        = map(string)
  default     = {}
}
