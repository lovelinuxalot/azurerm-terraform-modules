provider "azurerm" {
  features {}
}

module "test_rg" {
  source              = "../../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

module "test_net" {
  source               = "../../../../virtual_network"
  address_space        = ["10.0.1.0/24"]
  dns_servers          = []
  location             = module.test_rg.location
  resource_group_name  = module.test_rg.resource_group_name
  tags                 = {}
  virtual_network_name = "test_net"
}

module "test_subnet" {
  source               = "../../../../subnet"
  address_prefixes     = ["10.0.1.0/28"]
  resource_group_name  = module.test_rg.resource_group_name
  subnet_name          = "test_subnet"
  virtual_network_name = module.test_net.virtual_network_name
}

module "test_nic" {
  source                        = "../../.."
  location                      = module.test_rg.location
  resource_group_name           = module.test_rg.resource_group_name
  nic_name                      = var.nic_name
  ip_configuration_name         = var.ip_configuration_name
  public_ip_address_id          = var.public_ip_address_id
  subnet_id                     = module.test_subnet.subnet_id
  private_ip_address            = var.private_ip_address
  private_ip_address_allocation = var.private_ip_address_allocation
  tags                          = {}
  depends_on                    = [module.test_subnet]
}