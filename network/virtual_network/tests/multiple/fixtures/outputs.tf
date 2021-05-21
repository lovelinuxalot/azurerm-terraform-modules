output "virtual_network_id" {
  description = "Virtual network generated id"
  value       = { for rg in module.test_vnet_networking : rg.virtual_network_name => rg.virtual_network_id }
}

output "virtual_network_location" {
  description = "Virtual network location"
  value       = { for rg in module.test_vnet_networking : rg.virtual_network_name => rg.virtual_network_location }
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = { for rg in module.test_vnet_networking : rg.virtual_network_name => rg.virtual_network_name }
}

output "virtual_network_space" {
  description = "Virtual network space"
  value       = { for rg in module.test_vnet_networking : rg.virtual_network_name => rg.virtual_network_address_space }
}

output "virtual_network_resource_group_name" {
  description = "Virtual network Resource Group name"
  value       = { for rg in module.test_vnet_networking : rg.virtual_network_name => rg.virtual_network_resource_group_name }
}

output "resource_group_name" {
  value = ""
}