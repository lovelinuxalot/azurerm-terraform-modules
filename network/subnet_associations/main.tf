resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  count                     = length(var.subnet_nsg_associations)
  network_security_group_id = var.subnet_nsg_associations[count.index].network_security_group_id
  subnet_id                 = var.subnet_nsg_associations[count.index].subnet_id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_association" {
  count          = length(var.subnet_nat_associations)
  nat_gateway_id = var.subnet_nat_associations[count.index].nat_gateway_id
  subnet_id      = var.subnet_nat_associations[count.index].subnet_id
}