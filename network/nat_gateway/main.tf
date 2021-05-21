resource "azurerm_public_ip_prefix" "nat_public_ip_prefix" {
  count               = var.create_nat_prefix ? 1 : 0
  location            = var.location
  name                = var.nat_prefix_name
  resource_group_name = var.resource_group_name
  prefix_length       = var.nat_prefix_length
  tags                = var.tags
  sku                 = var.nat_prefix_sku
  zones               = var.nat_prefix_zones
}

resource "azurerm_public_ip" "nat_public_ip" {
  allocation_method   = var.nat_ip_allocation_method
  location            = var.location
  name                = var.nat_ip_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
  sku                 = var.nat_ip_sku
  ip_version          = var.nat_ip_version
  zones               = var.zones
  public_ip_prefix_id = var.create_nat_prefix ? azurerm_public_ip_prefix.nat_public_ip_prefix[0].id : var.nat_prefix_id
}

resource "azurerm_nat_gateway" "nat-gateway" {
  location            = var.location
  name                = var.nat_gateway_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_nat_gateway_public_ip_association" "nat-gateway-public-association" {
  nat_gateway_id       = azurerm_nat_gateway.nat-gateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}