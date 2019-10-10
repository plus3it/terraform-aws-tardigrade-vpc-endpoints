variable "create_sg_per_endpoint" {
  description = "toggle to create a sg for each vpc endpoint. Defaults to using just one for all endpoints."
  type        = bool
  default     = false
}

variable "create_vpc_endpoints" {
  description = "toggle to create vpc endpoints"
  type        = bool
  default     = true
}

variable "sg_egress_rules" {
  description = "Egress rules for the vpc endpoint sg(s). Set to empty list to disable default rules."
  type        = list
  default     = null
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the vpc endpoint sg(s). Set to empty list to disable default rules."
  type        = list
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "target subnet ids"
  default     = []
}

variable "vpc_endpoint_services" {
  type        = list(string)
  description = "List of aws endpoint service names that are used to create VPC Interface endpoints. See https://docs.aws.amazon.com/general/latest/gr/rande.html for full list."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to the VPC endpoint SG"
  type        = map(string)
  default     = {}
}

