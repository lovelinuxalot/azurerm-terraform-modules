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



module "test_subnet_rg" {
  source              = "../../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

variable "virtual_network_name" {
  default = ""
}
variable "address_space" {
  default = ""
}
variable "dns_servers" {
  default = ""
}
module "test_subnet_vnet" {
  source   = "../../../../virtual_network"
  location = var.location
  //  vnets = var.vnets
  address_space        = var.address_space
  dns_servers          = var.dns_servers
  resource_group_name  = module.test_subnet_rg.resource_group_name
  tags                 = {}
  virtual_network_name = var.virtual_network_name
}

module "test_nsg" {
  source                      = "../../../../network_security_group"
  location                    = var.location
  network_security_group_name = var.network_security_group_name
  resource_group_name         = module.test_subnet_rg.resource_group_name
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
      cidr              = ["10.0.1.0/26"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ServiceBus"]
      nsg_name          = module.test_nsg.network_security_group_name
      vnet_name         = module.test_subnet_vnet.virtual_network_name

    },
    {
      name              = "subnet2"
      cidr              = ["10.0.1.64/26"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Web"]
      nsg_name          = module.test_nsg.network_security_group_name
      vnet_name         = module.test_subnet_vnet.virtual_network_name
    }
  ]
}


module "test_subnet" {
  source               = "../../../../subnet"
  for_each             = { for subnet in local.subnets : subnet.name => subnet }
  subnet_name          = each.key
  virtual_network_name = module.test_subnet_vnet.virtual_network_name
  resource_group_name  = module.test_subnet_rg.resource_group_name
  address_prefixes     = each.value.cidr
  //  network_security_group_id = module.test_nsg.network_security_group_id
  service_endpoints = each.value.service_endpoints

  depends_on = [module.test_subnet_vnet]
}

module "test_subnet_assc" {
  source = "../../.."
  subnet_nsg_associations = [
    for subnet in module.test_subnet :
    {
      network_security_group_id = module.test_nsg.network_security_group_id
      subnet_id                 = subnet.subnet_id
    }
  ]
}
