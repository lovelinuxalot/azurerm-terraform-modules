variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}

variable "nat_prefix_name" {
  type = string
}
variable "nat_ip_name" {
  type = string
}
variable "nat_gateway_name" {
  type = string
}

provider "azurerm" {
  features {}
}


module "test_rg" {
  source              = "../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

data "azurerm_public_ip_prefix" "test_ngw_prefix" {
  name                = "terratest_nat_gw"
  resource_group_name = "test-nat-gw-pre"
}

module "test_nat_gw" {
  source                   = "../.."
  create_nat_prefix        = false
  location                 = module.test_rg.location
  resource_group_name      = module.test_rg.resource_group_name
  nat_ip_name              = var.nat_ip_name
  nat_ip_allocation_method = "Static"
  nat_ip_sku               = "Standard"
  nat_gateway_name         = var.nat_gateway_name
  tags                     = {}
  nat_prefix_id            = data.azurerm_public_ip_prefix.test_ngw_prefix.id
}