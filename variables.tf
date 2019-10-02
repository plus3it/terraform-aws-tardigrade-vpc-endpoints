variable "create_vpc_endpoints" {
  description = "toggle to create vpc endpoints"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "target subnet ids"
  default     = []
}

variable "vpc_endpoint_interfaces" {
  type        = list(string)
  description = "List of aws api endpoints that are used to create VPC Interface endpoints. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to the VPC endpoint SG"
  type        = map(string)
  default     = {}
}

