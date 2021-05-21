resource "azurerm_application_security_group" "asg" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface_application_security_group_association" "nic_asg_assoc" {
  count                         = var.asg_associate ? 1 : 0
  application_security_group_id = azurerm_application_security_group.asg.id
  network_interface_id          = var.network_interface_id
}