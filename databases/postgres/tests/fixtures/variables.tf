variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "storage_mb" {
  type = number
}
variable "server_name" {
  type = string
}
variable "sku_name" {
  type = string
}
variable "server_version" {
  type = string
}
variable "administrator_login" {
  type = string
}
variable "administrator_password" {
  type = string
}


variable "vnet_rule_name_prefix" {
  type = string
}
variable "fw_rule_prefix" {
  type = string
}
variable "fw_rules" {
  type = list(map(string))
}