locals {
  a_hostnames = ["abc.net", "def.net"]
  b_hostnames = ["uvw.net", "xyz.net"]
  a_backend_address_pool = [
    for host in local.a_hostnames : {
      name        = host
      ipaddresses = ["dfdsff"]
    }
  ]

  b_backend_address_pool = [
    for host in local.b_hostnames : {
      name        = host
      ipaddresses = ["dfdsff"]
    }
  ]

  frontend_ip_configuration_name = "test-feip"
  frontend_port_name             = "test-net-feport"
  nossl_frontend_port_name       = "test-net-nossl-feport"
  a_listener_name                = "test-net-a-httplstn"
  b_listener_name                = "test-net-b-httplstn"
  a_single_cluster               = length(local.a_hostnames) <= 1
  b_single_cluster               = length(local.b_hostnames) <= 1


  a_http_listeners = [
    for host in local.a_hostnames : {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      name                           = "${local.a_listener_name}${local.a_single_cluster ? "" : index(local.a_hostnames, host)}"
      protocol                       = "Http"
      host_name                      = host
      require_sni                    = false
    }
  ]

  a_http_listeners_nossl = [
    for host in local.a_hostnames : {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.nossl_frontend_port_name
      name                           = "${local.a_listener_name}-nossl-${local.a_single_cluster ? "" : index(local.a_hostnames, host)}"
      protocol                       = "Http"
      host_name                      = host
      require_sni                    = false
    }
  ]

  b_http_listeners = [
    for host in local.b_hostnames : {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      name                           = "${local.b_listener_name}${local.b_single_cluster ? "" : index(local.b_hostnames, host)}"
      protocol                       = "Http"
      host_name                      = host
      require_sni                    = false
    }
  ]

}

output "pool" {
  value = concat(local.a_http_listeners, local.a_http_listeners_nossl, local.b_http_listeners)
}


