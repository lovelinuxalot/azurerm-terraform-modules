provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test-asg" {
  name     = var.resource_group_name
  location = var.location
}

module "test_net" {
  source               = "../../../virtual_network"
  address_space        = ["10.0.1.0/24"]
  dns_servers          = []
  location             = var.location
  resource_group_name  = var.resource_group_name
  tags                 = {}
  virtual_network_name = "test_net"
}

module "test_subnet" {
  source               = "../../../subnet"
  address_prefixes     = ["10.0.1.0/28"]
  resource_group_name  = var.resource_group_name
  subnet_name          = "test_subnet"
  virtual_network_name = module.test_net.virtual_network_name
}

module "test_nic" {
  source                        = "../../.."
  location                      = var.location
  resource_group_name           = var.resource_group_name
  nic_name                      = "test-nic"
  ip_configuration_name         = "ip-testconfig"
  subnet_id                     = module.test_subnet.subnet_id
  private_ip_address_allocation = "Dynamic"
  tags                          = {}
  depends_on                    = [module.test_subnet]
}

module "web_ssh_rules" {
  source                      = "../../../network_security_group"
  network_security_group_name = "test-nsg"
  resource_group_name         = azurerm_resource_group.test-asg.name
  location                    = var.location
  tags                        = {}
  custom_rules = [
    {
      name                       = "webrule"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 101
      protocol                   = "tcp"
      source_address_prefix      = "*"
      source_port_ranges         = ["*"]
      destination_address_prefix = "*"
      destination_port_ranges    = ["80"]
      description                = "test web open"
    },
    {
      name                         = "AllowSSHFromNET"
      access                       = "Allow"
      direction                    = "Inbound"
      priority                     = 100
      protocol                     = "tcp"
      source_address_prefixes      = ["10.0.10.0/24", "10.0.20.0/24"]
      source_port_ranges           = ["100-250", "300-352"]
      destination_address_prefixes = ["10.0.30.0/24", "10.0.40.0/24"]
      destination_port_ranges      = ["22", "443"]
      description                  = "test ssh open"
    }
  ]
}

module "test-asg" {
  source              = "../../"
  name                = "test-asg"
  location            = var.location
  resource_group_name = var.resource_group_name
  asg_associate       = false
}

