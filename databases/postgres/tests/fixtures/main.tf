provider "azurerm" {
  features {}
}

module "test_rg" {
  source              = "../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

module "test_net" {
  source               = "../../../../network/virtual_network"
  address_space        = ["10.0.1.0/24"]
  dns_servers          = []
  location             = module.test_rg.location
  resource_group_name  = module.test_rg.resource_group_name
  tags                 = {}
  virtual_network_name = "test_net"
}

module "test-subnet-1" {
  source               = "../../../../network/subnet"
  address_prefixes     = ["10.0.1.0/28"]
  resource_group_name  = module.test_rg.resource_group_name
  subnet_name          = "test-subnet-1"
  virtual_network_name = module.test_net.virtual_network_name
  service_endpoints    = ["Microsoft.Sql"]
}

module "test-subnet-2" {
  source               = "../../../../network/subnet"
  address_prefixes     = ["10.0.1.128/28"]
  resource_group_name  = module.test_rg.resource_group_name
  subnet_name          = "test-subnet-2"
  virtual_network_name = module.test_net.virtual_network_name
  service_endpoints    = ["Microsoft.Sql"]
}

module "test_postgres" {
  source                       = "../.."
  administrator_login          = var.administrator_login
  administrator_password       = var.administrator_password
  location                     = var.location
  resource_group_name          = module.test_rg.resource_group_name
  server_name                  = var.server_name
  sku_name                     = var.sku_name
  server_version               = var.server_version
  ssl_enforcement_enabled      = false
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true
  storage_mb                   = var.storage_mb

  vnet_rule_name_prefix = var.vnet_rule_name_prefix
  vnet_rules = [
    { name = module.test-subnet-1.subnet_name, subnet_id = module.test-subnet-1.subnet_id },
    { name = module.test-subnet-2.subnet_name, subnet_id = module.test-subnet-2.subnet_id }
  ]
  firewall_rule_prefix = var.fw_rule_prefix
  firewall_rules       = var.fw_rules
}