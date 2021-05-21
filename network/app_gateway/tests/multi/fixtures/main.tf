provider "azurerm" {
  features {}
}

variable "location" {
  default = ""
}
variable "resource_group_name" {
  default = ""
}
variable "a_hostnames" {
  type = any
}
variable "b_hostnames" {
  type = any
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
  virtual_network_name = "test_net_appgw"
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
  //  a_single_cluster = length(var.a_hostnames) <= 1
  a_backend_address_pool_name    = "${module.test_net.virtual_network_name}-a-beap"
  a_http_setting_name            = "${module.test_net.virtual_network_name}-a-be-htst"
  frontend_ip_configuration_name = "${module.test_net.virtual_network_name}-feip"
  frontend_port_name             = "${module.test_net.virtual_network_name}-feport"
  nossl_frontend_port_name       = "${module.test_net.virtual_network_name}-nossl-feport"
  a_listener_name                = "${module.test_net.virtual_network_name}-a-httplstn"
  a_request_routing_rule_name    = "${module.test_net.virtual_network_name}-a-rqrt"
  a_redirect_routing_rule_name   = "${module.test_net.virtual_network_name}-a-rdrt"
  a_redirect_configuration_name  = "${module.test_net.virtual_network_name}-a-rdrcfg"

  //  b_single_cluster = length(var.b_hostnames) <= 1
  b_backend_address_pool_name   = "${module.test_net.virtual_network_name}-b-beap"
  b_http_setting_name           = "${module.test_net.virtual_network_name}-b-be-htst"
  b_listener_name               = "${module.test_net.virtual_network_name}-b-httplstn"
  b_request_routing_rule_name   = "${module.test_net.virtual_network_name}-b-rqrt"
  b_redirect_configuration_name = "${module.test_net.virtual_network_name}-b-rdrcfg"


  frontend_ip_configuration = [
    {
      name                          = local.frontend_ip_configuration_name
      private_ip_address            = "10.0.1.8"
      private_ip_address_allocation = "Static"
      subnet_id                     = module.test_subnet_frontend.subnet_id
    }
  ]
  a_backend_address_pool = [
    for host, _ in var.a_hostnames : {
      name = "${local.a_backend_address_pool_name}-${host}"
    }
  ]
  b_backend_address_pool = [
    for host, value in var.b_hostnames : {
      name = "${local.b_backend_address_pool_name}-${host}"
    }
  ]

  a_backend_http_settings = [
    for host, _ in var.a_hostnames : {
      cookie_based_affinity = "Enabled"
      name                  = "${local.a_http_setting_name}-${host}"
      port                  = 8443
      request_timeout       = 30
      protocol              = "Http"
      affinity_cookie_name  = "ApplicationGatewayAffinity"
    }
  ]

  b_backend_http_settings = [
    for host, _ in var.b_hostnames : {
      cookie_based_affinity = "Enabled"
      name                  = "${local.b_http_setting_name}-${host}"
      port                  = 8443
      path                  = "/"
      request_timeout       = 30
      protocol              = "Http"
    }
  ]

  a_http_listeners = [
    for host, _ in var.a_hostnames : {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      name                           = "${local.a_listener_name}-${host}"
      protocol                       = "Http"
      host_name                      = host
      require_sni                    = false
    }
  ]

  a_http_listeners_nossl = [
    for host, _ in var.a_hostnames : {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.nossl_frontend_port_name
      name                           = "${local.a_listener_name}-nossl-${host}"
      protocol                       = "Http"
      host_name                      = host
      require_sni                    = false
    }
  ]

  b_http_listeners = [
    for host, _ in var.b_hostnames : {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      name                           = "${local.b_listener_name}-${host}"
      protocol                       = "Http"
      host_name                      = host
      require_sni                    = false
    }
  ]

  a_basic_request_routing_rules = [
    for host, _ in var.a_hostnames : {
      name                       = "${local.a_request_routing_rule_name}-${host}"
      http_listener_name         = "${local.a_listener_name}-${host}"
      rule_type                  = "Basic"
      backend_address_pool_name  = "${local.a_backend_address_pool_name}-${host}"
      backend_http_settings_name = "${local.a_http_setting_name}-${host}"
    }
  ]

  b_basic_request_routing_rules = [
    for host, _ in var.b_hostnames : {
      name                       = "${local.b_request_routing_rule_name}-${host}"
      http_listener_name         = "${local.b_listener_name}-${host}"
      rule_type                  = "Basic"
      backend_address_pool_name  = "${local.b_backend_address_pool_name}-${host}"
      backend_http_settings_name = "${local.b_http_setting_name}-${host}"
    }
  ]

  a_redirect_request_routing_rules = [
    for host, _ in var.a_hostnames : {
      http_listener_name          = "${local.a_listener_name}-nossl-${host}"
      name                        = "${local.a_redirect_routing_rule_name}-${host}"
      rule_type                   = "Basic"
      redirect_configuration_name = "${local.a_redirect_configuration_name}-${host}"
    }
  ]

  a_redirect_configurations = [
    for host, _ in var.a_hostnames : {
      name                 = "${local.a_redirect_configuration_name}-${host}"
      redirect_type        = "Permanent"
      target_listener_name = "${local.a_listener_name}-${host}"
      target_url           = null
      include_path         = true
      include_query_string = true
    }
  ]

}

module "test_app_gateway" {
  source              = "../../.."
  name                = "test_app_gateway"
  location            = var.location
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
      port = 8080
    },
    {
      name = local.nossl_frontend_port_name
      port = 444
    }
  ]
  frontend_ip_configuration = concat(local.frontend_ip_configuration)

  //  frontend_ip_configuration = {
  //    name = local.frontend_ip_configuration_name
  //    public_ip_address_id = azurerm_public_ip.test_public_ip.id
  //  }

  backend_address_pools = concat(local.a_backend_address_pool, local.b_backend_address_pool)
  backend_http_settings = concat(local.a_backend_http_settings, local.b_backend_http_settings)

  http_listeners = concat(local.a_http_listeners, local.a_http_listeners_nossl, local.b_http_listeners)

  basic_request_routing_rules    = concat(local.a_basic_request_routing_rules, local.b_basic_request_routing_rules)
  redirect_request_routing_rules = local.a_redirect_request_routing_rules
  redirect_configurations        = local.a_redirect_configurations

}