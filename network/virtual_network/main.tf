resource "azurerm_virtual_network" "virtual_network" {
  location            = var.location
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}