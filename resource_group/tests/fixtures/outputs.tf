output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  description = "Resource group name"
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
  description = "Resource group generated id"
}

output "resource_group_location" {
  value       = module.resource_group.location
  description = "Resource group location (region)"
}