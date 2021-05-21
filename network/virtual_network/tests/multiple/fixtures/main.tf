provider "azurerm" {
  features {}
}

module "test_rg" {
  source              = "../../../../../resource_group"
  for_each            = { for rg in var.vnets : rg.resource_group_name => rg }
  location            = var.location
  resource_group_name = each.key
  tags                = {}
}

module "test_vnet_networking" {
  source               = "../../.."
  for_each             = { for vnet in var.vnets : vnet.virtual_network_name => vnet }
  address_space        = each.value.address_space
  dns_servers          = each.value.dns_servers
  location             = var.location
  resource_group_name  = each.value.resource_group_name
  tags                 = each.value.tags
  virtual_network_name = each.key
  depends_on           = [module.test_rg]
}
