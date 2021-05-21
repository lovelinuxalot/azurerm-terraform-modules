provider "azurerm" {
  features {}
}

variable "location" {
  default = ""
}
variable "resource_group_name" {
  default = ""
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

module "test_subnet_frontend" {
  source               = "../../../../subnet"
  address_prefixes     = ["10.0.1.0/28"]
  resource_group_name  = module.test_rg.resource_group_name
  subnet_name          = "test_subnet_frontend"
  virtual_network_name = module.test_net.virtual_network_name
}

module "test_subnet_backend" {
  source               = "../../../../subnet"
  address_prefixes     = ["10.0.1.128/28"]
  resource_group_name  = module.test_rg.resource_group_name
  subnet_name          = "test_subnet_backend"
  virtual_network_name = module.test_net.virtual_network_name
}

resource "azurerm_public_ip" "test_public_ip" {
  name                = "test_public_ip"
  resource_group_name = module.test_rg.resource_group_name
  location            = module.test_rg.location
  allocation_method   = "Dynamic"
}

locals {
  backend_address_pool_name      = "${module.test_net.virtual_network_name}-beap"
  frontend_port_name             = "${module.test_net.virtual_network_name}-feport"
  frontend_ip_configuration_name = "${module.test_net.virtual_network_name}-feip"
  http_setting_name              = "${module.test_net.virtual_network_name}-be-htst"
  listener_name                  = "${module.test_net.virtual_network_name}-httplstn"
  request_routing_rule_name      = "${module.test_net.virtual_network_name}-rqrt"
  redirect_configuration_name    = "${module.test_net.virtual_network_name}-rdrcfg"
}

module "test_app_gateway" {
  source              = "../../.."
  name                = "test_app_gateway"
  location            = module.test_rg.location
  resource_group_name = module.test_rg.resource_group_name

  sku_capacity = 2
  sku_name     = "Standard_Small"
  sku_tier     = "Standard"

  gateway_ip_configuration = {
    name      = "test-gateway"
    subnet_id = module.test_subnet_frontend.subnet_id
  }

  frontend_ports = [
    {
      name = local.frontend_port_name,
      port = 80
    }
  ]

  frontend_ip_configuration = {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.test_public_ip.id
  }

  backend_address_pools = [
    {
      name = local.backend_address_pool_name
    },
  ]

  backend_http_settings = [
    {
      cookie_based_affinity = "Disabled"
      name                  = local.http_setting_name
      port                  = 80
      path                  = "/"
      request_timeout       = 30
      protocol              = "Http"
    },
  ]

  http_listeners = [
    {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      name                           = local.listener_name
      protocol                       = "Http"
    }
  ]

  basic_request_routing_rules = [
    {
      name                       = local.request_routing_rule_name
      http_listener_name         = local.listener_name
      rule_type                  = "Basic"
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.http_setting_name
    }
  ]
}