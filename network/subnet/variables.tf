variable "subnet_name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "virtual_network_name" {
  //  type = string
}
variable "address_prefixes" {
  type = list(string)
}
variable "service_endpoints" {
  type    = list(string)
  default = []
}
variable "enforce_private_link_endpoint_network_policies" {
  type    = bool
  default = false
}
//variable "network_security_group_id" {
//  type = string
//  default = null
//}
//variable "nat_gateway_id" {
//  type = string
//  default = null
//}