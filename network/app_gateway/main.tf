resource "azurerm_application_gateway" "app_gateway" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  firewall_policy_id  = var.firewall_policy_id

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  autoscale_configuration {
    min_capacity = lookup(var.autoscale_configuration, "min_capacity", 0)
    max_capacity = lookup(var.autoscale_configuration, "max_capacity", 2)
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration
    content {
      name                          = lookup(frontend_ip_configuration.value, "name", "default-frontend-ip-name")
      subnet_id                     = lookup(frontend_ip_configuration.value, "subnet_id", null)
      private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      public_ip_address_id          = lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", null)
    }
  }

  gateway_ip_configuration {
    name      = lookup(var.gateway_ip_configuration, "name", "default-gateway-ip-name")
    subnet_id = lookup(var.gateway_ip_configuration, "subnet_id", "")
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      path                                = lookup(backend_http_settings.value, "path", null)
      probe_name                          = lookup(backend_http_settings.value, "probe_name", null)
      host_name                           = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", false) == false ? lookup(backend_http_settings.value, "host_name", null) : null
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "host_name", null) == null ? lookup(backend_http_settings.value, "pick_host_name_from_backend_address", false) : false
      affinity_cookie_name                = lookup(backend_http_settings.value, "affinity_cookie_name", null)
      trusted_root_certificate_names      = lookup(backend_http_settings.value, "trusted_root_certificate_names", [])

      dynamic "connection_draining" {
        for_each = lookup(backend_http_settings.value, "connection_draining_enabled", {}) != {} ? [backend_http_settings.value.connection_draining] : []
        content {
          drain_timeout_sec = backend_http_settings.value.connection_draining.drain_timeout_sec
          enabled           = backend_http_settings.value.connection_draining.enabled
        }
      }

      dynamic "authentication_certificate" {
        for_each = lookup(backend_http_settings.value, "authentication_certificate_name", "") != "" ? [backend_http_settings.value.authentication_certificate_name] : []
        content {
          name = backend_http_settings.value.authentication_certificate_name
        }
      }

    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = lookup(http_listener.value, "name", null)
      frontend_ip_configuration_name = lookup(http_listener.value, "frontend_ip_configuration_name", null)
      frontend_port_name             = lookup(http_listener.value, "frontend_port_name", null)
      protocol                       = lookup(http_listener.value, "protocol", "Http")
      host_name                      = lookup(http_listener.value, "host_name", null)
      require_sni                    = lookup(http_listener.value, "require_sni", false)
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      firewall_policy_id             = lookup(http_listener.value, "firewall_policy_id", null)
    }
  }

  ssl_policy {
    disabled_protocols   = lookup(var.ssl_policy, "policy_type", null) == null || lookup(var.ssl_policy, "policy_name", null) == null ? lookup(var.ssl_policy, "disabled_protocols", []) : []
    policy_type          = lookup(var.ssl_policy, "disabled_protocols", []) == [] && lookup(var.ssl_policy, "policy_name", null) == null ? lookup(var.ssl_policy, "policy_type", null) : null
    policy_name          = lookup(var.ssl_policy, "disabled_protocols", []) == [] && lookup(var.ssl_policy, "policy_type", null) != null ? lookup(var.ssl_policy, "policy_name", null) : null
    cipher_suites        = lookup(var.ssl_policy, "policy_type", null) == "Custom" ? lookup(var.ssl_policy, "cipher_suites", []) : null
    min_protocol_version = lookup(var.ssl_policy, "policy_type", null) == "Custom" ? lookup(var.ssl_policy, "min_protocol_version", null) : null
  }

  // Basic Rules
  dynamic "request_routing_rule" {
    for_each = var.basic_request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = "Basic"
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      rewrite_rule_set_name      = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
    }
  }

  // Redirect Rules
  dynamic "request_routing_rule" {
    for_each = var.redirect_request_routing_rules
    content {
      name                        = lookup(request_routing_rule.value, "name", null)
      rule_type                   = "Basic"
      http_listener_name          = lookup(request_routing_rule.value, "http_listener_name", null)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null)
    }
  }

  // Path based rules
  dynamic "request_routing_rule" {
    for_each = var.path_based_request_routing_rules
    content {
      name                  = request_routing_rule.value.name
      rule_type             = "PathBasedRouting"
      http_listener_name    = request_routing_rule.value.http_listener_name
      url_path_map_name     = request_routing_rule.value.url_path_map_name
      rewrite_rule_set_name = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations
    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = lookup(redirect_configuration.value, "target_url", null) == null ? redirect_configuration.value.target_listener_name : null
      target_url           = lookup(redirect_configuration.value, "target_listener_name", null) == null ? redirect_configuration.value.target_url : null
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name     = ssl_certificate.value.name
      data     = filebase64(ssl_certificate.value.pfx_cert_filepath)
      password = ssl_certificate.value.pfx_cert_password
    }
  }

  dynamic "authentication_certificate" {
    for_each = var.authentication_certificates
    content {
      data = authentication_certificate.value.data
      name = authentication_certificate.value.name
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificates
    content {
      data = trusted_root_certificate.value.data
      name = trusted_root_certificate.value.name
    }
  }

  dynamic "waf_configuration" {
    for_each = var.waf_configurations
    content {
      enabled                  = waf_configuration.value.enabled
      firewall_mode            = waf_configuration.value.firewall_mode
      rule_set_version         = waf_configuration.value.rule_set_version
      rule_set_type            = lookup(waf_configuration.value, "rule_set_type", null)
      max_request_body_size_kb = lookup(waf_configuration.value, "max_request_body_size_kb", null)
      file_upload_limit_mb     = lookup(waf_configuration.value, "file_upload_limit_mb", 100)
      request_body_check       = lookup(waf_configuration.value, "request_body_check", false)

      dynamic "disabled_rule_group" {
        for_each = lookup(waf_configuration.value, "disabled_rule_groups", [])
        content {
          rule_group_name = lookup(disabled_rule_group.value, "rule_group_name", null)
          rules           = lookup(disabled_rule_group.value, "rules", [])
        }
      }
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      interval                                  = 30
      name                                      = probe.value.name
      path                                      = probe.value.path
      protocol                                  = probe.value.protocol
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_maps
    content {
      name                               = url_path_map.value.name
      default_backend_http_settings_name = url_path_map.value.default_backend_http_settings_name
      default_backend_address_pool_name  = url_path_map.value.default_backend_address_pool_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules
        content {
          name                       = path_rule.value.name
          backend_address_pool_name  = path_rule.value.backend_address_pool_name
          backend_http_settings_name = path_rule.value.backend_http_settings_name
          paths                      = path_rule.value.paths
        }
      }
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_sets
    content {
      name = rewrite_rule_set.value.name

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rules
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_headers
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_headers
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }
          }
        }
      }
    }
  }
}