provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  default = ""
}
variable "location" {
  default = ""
}
variable "vnets" {
  default = ""
}
variable "network_security_group_name" {
  default = ""
}



module "test_rg" {
  source              = "../../../../../resource_group"
  for_each            = { for rg in var.vnets : rg.resource_group_name => rg }
  location            = var.location
  resource_group_name = each.key
  tags                = {}
}

module "test_vnet" {
  source               = "../../../../virtual_network"
  for_each             = { for vnet in var.vnets : vnet.virtual_network_name => vnet }
  address_space        = each.value.address_space
  dns_servers          = each.value.dns_servers
  location             = var.location
  resource_group_name  = each.value.resource_group_name
  tags                 = each.value.tags
  virtual_network_name = each.key
  depends_on           = [module.test_rg]
}

module "test_nsg" {
  source                      = "../../../../network_security_group"
  location                    = var.location
  network_security_group_name = var.network_security_group_name
  resource_group_name         = module.test_rg.resource_group_name
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
    }
  ]
}

locals {
  subnets = [
    {
      name              = "subnet1"
      cidr              = ["10.0.2.0/26"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ServiceBus"]
      nsg_name          = module.test_nsg.network_security_group_name
      vnet_name         = module.test_vnet.virtual_network_name

    },
    {
      name              = "subnet2"
      cidr              = ["10.0.1.64/26"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Web"]
      nsg_name          = module.test_nsg.network_security_group_name
      vnet_name         = module.test_vnet.virtual_network_name
    }
  ]
}


module "test_subnet" {
  source                    = "../../.."
  for_each                  = { for subnet in local.subnets : subnet.name => subnet }
  subnet_name               = each.key
  virtual_network_name      = module.test_vnet.virtual_network_name
  resource_group_name       = module.test_rg.resource_group_name
  address_prefixes          = each.value.cidr
  network_security_group_id = module.test_nsg.network_security_group_id
  service_endpoints         = each.value.service_endpoints

  depends_on = [module.test_vnet]
}
