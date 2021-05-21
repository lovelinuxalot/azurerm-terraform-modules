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
variable "private_ip_address" {
  type = string
}
variable "private_ip_address_allocation" {
  type = string
}

variable "vm_name" {
  type = string
}
variable "vm_size" {
  type = string
}

variable "disk_size_gb" {
  type    = number
  default = null
}
variable "admin_username" {
  type = string
}