variable "nic_name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "enable_ip_forwarding" {
  type    = bool
  default = false
}
variable "enable_accelerated_networking" {
  type    = bool
  default = false
}

variable "ip_configuration_name" {
  type = string
}
variable "public_ip_address_id" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "private_ip_address_version" {
  type    = string
  default = "IPv4"
}
variable "tags" {
  type = map(string)
}
variable "private_ip_address" {
  type    = string
  default = null
}
variable "private_ip_address_allocation" {
  type    = string
  default = "Dynamic"
}