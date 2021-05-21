provider "azurerm" {
  features {}
}

module "test_single_rg" {
  source              = "../../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

module "test_single_virtual_network" {
  source               = "../../.."
  address_space        = var.address_space
  dns_servers          = var.dns_servers
  location             = var.location
  resource_group_name  = var.resource_group_name
  tags                 = var.tags
  virtual_network_name = var.virtual_network_name
  depends_on           = [module.test_single_rg]
}

