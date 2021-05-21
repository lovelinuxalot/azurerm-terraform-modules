variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}


variable "nic_name" {
  type = string
}
variable "ip_configuration_name" {
  type = string
}
variable "public_ip_address_id" {
  type    = string
  default = null
}
//variable "subnet_id" {
//  type = string
//}

variable "private_ip_address" {
  type    = string
  default = null
}
variable "private_ip_address_allocation" {
  type    = string
  default = "Dynamic"
}