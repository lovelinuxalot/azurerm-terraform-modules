output "virtual_network_id" {
  description = "Virtual network generated id"
  value       = module.test_single_virtual_network.virtual_network_id
}

output "virtual_network_location" {
  description = "Virtual network location"
  value       = module.test_single_virtual_network.virtual_network_location
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = module.test_single_virtual_network.virtual_network_name
}

output "virtual_network_space" {
  description = "Virtual network space"
  value       = module.test_single_virtual_network.virtual_network_address_space
}

output "virtual_network_resource_group_name" {
  description = "Virtual network Resource Group name"
  value       = module.test_single_virtual_network.virtual_network_resource_group_name
}