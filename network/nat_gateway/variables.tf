variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "nat_gateway_name" {
  type = string
}
variable "nat_ip_allocation_method" {
  type = string
}
variable "nat_ip_name" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "nat_ip_sku" {
  type = string
}
variable "nat_ip_version" {
  type    = string
  default = "IPv4"
}
variable "zones" {
  default = []
}
variable "nat_prefix_name" {
  type    = string
  default = ""
}
variable "nat_prefix_length" {
  type    = number
  default = 28
}
variable "nat_prefix_sku" {
  type    = string
  default = "Standard"
}
variable "nat_prefix_zones" {
  type    = list(string)
  default = []
}
variable "create_nat_prefix" {
  type    = bool
  default = true
}
variable "nat_prefix_id" {
  type = string
}