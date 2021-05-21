provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test-nsg" {
  name     = var.resource_group_name
  location = var.location
}

module "web_ssh_rules" {
  source                      = "../.."
  network_security_group_name = var.network_security_group_name
  resource_group_name         = azurerm_resource_group.test-nsg.name
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

