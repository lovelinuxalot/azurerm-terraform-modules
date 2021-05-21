output "app_gateway_id" {
  value = azurerm_application_gateway.app_gateway.id
}

output "app_gateway_name" {
  value = azurerm_application_gateway.app_gateway.name
}

output "app_gateway_full" {
  value = azurerm_application_gateway.app_gateway
}

output "backend_pools" {
  value = azurerm_application_gateway.app_gateway.backend_address_pool
}

output "backend_pools_with_name" {
  value = { for backend in azurerm_application_gateway.app_gateway.backend_address_pool : backend.name => backend }
}