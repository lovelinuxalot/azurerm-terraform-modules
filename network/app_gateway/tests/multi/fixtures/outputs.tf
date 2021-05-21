output "app_gw_name" {
  value = module.test_app_gateway.app_gateway_name
}

output "app_gw_rg" {
  value = module.test_rg.resource_group_name
}

output "app_gw_frontend_ports" {
  value = flatten(module.test_app_gateway.app_gateway_full.frontend_port)[0].name
}

output "backend_pools" {
  value = module.test_app_gateway.backend_pools[*]
}
