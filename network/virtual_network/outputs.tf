output "virtual_network_id" {
  description = "Virtual network generated id"
  value       = azurerm_virtual_network.virtual_network.id
}

output "virtual_network_location" {
  description = "Virtual network location"
  value       = azurerm_virtual_network.virtual_network.location
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.virtual_network.name
}

output "virtual_network_address_space" {
  description = "Virtual network space"
  value       = azurerm_virtual_network.virtual_network.address_space
}

output "virtual_network_resource_group_name" {
  description = "Virtual network Resource Group name"
  value       = azurerm_virtual_network.virtual_network.resource_group_name
}