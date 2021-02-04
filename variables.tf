variable "create_sg_per_endpoint" {
  description = "Toggle to create a SecurityGroup for each VPC Endpoint. Defaults to using just one for all Interface Endpoints. Note that Gateway Endpoints don't support SecurityGroups."
  type        = bool
  default     = false
}

variable "create_vpc_endpoints" {
  description = "Toggle to create VPC Endpoints."
  type        = bool
  default     = true
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
  type        = list(string)
  description = "Target Subnet ids."
  default     = []
}

variable "vpc_endpoint_services" {
  type        = list(string)
  description = "List of AWS Endpoint service names that are used to create VPC Interface Endpoints. Both Gateway and Interface Endpoints are supported. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to the VPC Endpoint and to the SecurityGroup(s)."
  type        = map(string)
  default     = {}
}

locals {
  # if list contains s3

  s3_service_found = contains(var.vpc_endpoint_services, "s3")

  # slice out everything but the s3 bit

  s3_service_index = local.s3_service_found ? index(var.vpc_endpoint_services, "s3") : -1

  # assumes s3 index not at ends
  pre_s3_part  = local.s3_service_found ? slice(var.vpc_endpoint_services, 0, local.s3_service_index) : []
  post_s3_part = local.s3_service_found ? slice(var.vpc_endpoint_services, local.s3_service_index + 1, length(var.vpc_endpoint_services) - 1) : var.vpc_endpoint_services

  # merge non-s3 pieces together

  vpc_endpoint_services = concat(local.pre_s3_part, local.post_s3_part)
}
