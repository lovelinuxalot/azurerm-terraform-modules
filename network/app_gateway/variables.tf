variable "location" {
  description = "The Azure location to deploy the resource to"
  type = string
}

variable "name" {
  description = "The name of the Application Gateway to be created"
  type = string
}

variable "resource_group_name" {
  description = "The Azure Resource Group to deploy the resource to"
  type = string
}

variable "backend_address_pools" {
  description = "List of backend address pools."
  //  type = list(object({
  //    name         = string
  //    ip_addresses = list(string)
  //    fqdns        = list(string)
  //  }))
  type    = any
  default = []
}

//Todo add defaults and use merge to use defaults and merge with locals
variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  //  type = list(object({
  //    name            = string
  //    path            = string
  //    request_timeout = string
  //    probe_name      = string
  //    cookie_based_affinity               = string
  //    port                                = number
  //    protocol                            = string
  //    path                                = string
  //    probe_name                          = string
  //    host_name                           = string
  //    pick_host_name_from_backend_address = bool
  //    affinity_cookie_name                = string
  //    trusted_root_certificate_names = list(string)
  //
  //  }))
  type    = any
  default = []
}

variable "sku_name" {
  type = string
}
variable "sku_tier" {
  type = string
}
variable "sku_capacity" {
  type    = number
  default = null
}

variable "frontend_ip_configuration" {
  //  type = map(string)
  type = any
}
variable "gateway_ip_configuration" {
  type = map(string)
}

variable "frontend_ports" {
  description = "List of Frontend ports"
  type = list(object({
    name = string
    port = number
  }))
}

variable "http_listeners" {
  description = "List of HTTP/HTTPS listeners. HTTPS listeners require an SSL Certificate object."
  //  type = list(object({
  //    name                 = string
  //    ssl_certificate_name = string
  //    host_name            = string
  //  }))
  type = any
}

variable "basic_request_routing_rules" {
  description = "Request routing rules to be used for listeners."
  //  type = list(object({
  //    name                        = string
  //    http_listener_name          = string
  //    backend_address_pool_name   = string
  //    backend_http_settings_name  = string
  //  }))
  type    = any
  default = []
}

variable "redirect_request_routing_rules" {
  description = "Request routing rules to be used for listeners."
  //  type = list(object({
  //    name                        = string
  //    http_listener_name          = string
  //    redirect_configuration_name = string
  //  }))
  type    = any
  default = []
}

variable "path_based_request_routing_rules" {
  description = "Request routing rules to be used for listeners."
  //  type = list(object({
  //    name               = string
  //    http_listener_name = string
  //    url_path_map_name  = string
  //  }))
  type    = any
  default = []
}

variable "redirect_configurations" {
  description = "A collection of redirect configurations."
  default     = []
  type        = any
  //  type = list(object({
  //    name                 = string
  //    redirect_type        = string
  //    target_listener_name = string
  //    target_url           = string
  //    include_path         = bool
  //    include_query_string = bool
  //  }))
}

variable "ssl_certificates" {
  description = "SSL Certificate objects to be used for HTTPS listeners. Requires a PFX certificate stored on the machine running the Terraform apply."
  default     = []
  type        = any
  //  type = list(object({
  //    name              = string
  //    pfx_cert_filepath = string
  //    pfx_cert_password = string
  //  }))
}

variable "authentication_certificates" {
  description = "SSL Certificate for authentication"
  default     = []
  type        = any
  //  type = list(object({
  //    name              = string
  //    data              = string
  //  }))
}

variable "trusted_root_certificates" {
  type    = any
  default = []
}
variable "waf_configurations" {
  description = "WAF Configurations"
  default     = []
  type        = any
  //  type = list(object({
  //    enabled = bool
  //    firewall_mode = string
  //    rule_set_version = string
  //    rule_set_type = string
  //    max_request_body_size_kb = number
  //  }))
}

variable "probes" {
  description = "Health probes used to test backend health."
  default     = []
  type = list(object({
    name     = string
    path     = string
    is_https = bool
  }))
}

variable "url_path_maps" {
  description = "URL path maps associated to path-based rules."
  default     = []
  type = list(object({
    name                               = string
    default_backend_http_settings_name = string
    default_backend_address_pool_name  = string
    path_rules = list(object({
      name                       = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      paths                      = list(string)
    }))
  }))
}

variable "ssl_policy" {
  type = any
}

variable "autoscale_configuration" {
  type = any
}

variable "rewrite_rule_sets" {
  type    = any
  default = []
}

variable "firewall_policy_id" {
  type    = string
  default = null
}