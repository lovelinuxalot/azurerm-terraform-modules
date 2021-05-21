resource "azurerm_subnet" "subnet" {
  name                                           = var.subnet_name
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = var.virtual_network_name
  address_prefixes                               = var.address_prefixes
  service_endpoints                              = var.service_endpoints
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
  //  network_security_group_id = var.network_security_group_id
}

//resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
//  count = var.network_security_group_id != null ? 1 : 0
//  network_security_group_id = var.network_security_group_id
//  subnet_id = azurerm_subnet.subnet.id
//}

//resource "azurerm_subnet_nat_gateway_association" "subnet_nat_association" {
//  count = var.nat_gateway_id != null ? 1 : 0
//  nat_gateway_id = var.nat_gateway_id
//  subnet_id = azurerm_subnet.subnet.id
//}