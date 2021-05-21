output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  value       = azurerm_resource_group.resource_group.id
  description = "Resource group generated id"
}

output "location" {
  value = azurerm_resource_group.resource_group.location
}
