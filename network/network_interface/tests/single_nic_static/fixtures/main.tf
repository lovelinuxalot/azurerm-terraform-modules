variable "location" {
  default = ""
}
variable "resource_group_name" {
  default = ""
}
module "test_rg" {
  source              = "../../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

variable "nic_name" {
  default = ""
}
variable "ip_configuration_name" {
  default = ""
}
variable "private_ip_address" {
  default = ""
}
variable "private_ip_address_allocation" {
  default = ""
}
variable "public_ip_address_id" {
  default = ""
}
variable "subnet_id" {
  default = ""
}
module "test_nic" {
  source                        = "../../.."
  location                      = var.location
  resource_group_name           = var.resource_group_name
  nic_name                      = var.nic_name
  ip_configuration_name         = var.ip_configuration_name
  private_ip_address            = var.private_ip_address
  private_ip_address_allocation = var.private_ip_address_allocation
  public_ip_address_id          = var.public_ip_address_id
  subnet_id                     = var.subnet_id
  tags                          = {}
}