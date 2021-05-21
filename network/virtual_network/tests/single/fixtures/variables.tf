variable "location" {
  type = string
}
variable "virtual_network_name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "address_space" {
  type = list(string)
}
variable "dns_servers" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}