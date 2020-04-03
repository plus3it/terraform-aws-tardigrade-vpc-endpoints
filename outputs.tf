output "vpc_endpoint_sgs" {
  value = aws_security_group.this
}

output "vpc_endpoint_interface_services" {
  value = aws_vpc_endpoint.interface_services
}

output "vpc_endpoint_gateway_services" {
  value = aws_vpc_endpoint.gateway_services
}
