variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "network_security_group_name" {
  type = string
}
//variable "custom_rules" {
//  type = list(object({
//    name = string
//    resource_group_name = string
//    network_security_group_name = string
//    access = string
//    direction = string
//    priority = number
//    protocol = string
//    source_address_prefix = string
//    source_address_prefixes = list(string)
//    source_port_ranges = list(string)
//    destination_address_prefix = string
//    destination_address_prefixes = list(string)
//    destination_port_ranges = list(string)
//    description = string
//  }))
//}
variable "custom_rules" {
  type = any

}