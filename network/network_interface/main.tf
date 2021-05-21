resource "azurerm_network_interface" "vm_nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding
  tags                          = var.tags

  ip_configuration {
    name                       = var.ip_configuration_name
    subnet_id                  = var.subnet_id
    private_ip_address_version = var.private_ip_address_version

    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address_allocation == "Static" ? var.private_ip_address : null

    public_ip_address_id = var.public_ip_address_id == null ? null : var.public_ip_address_id
  }
}