output "test_subnet_id" {
  description = "Id of the created subnet"
  value       = { for item in module.test_subnet : item.subnet_name => item.subnet_id }
}

output "test_subnet_address_prefixes" {
  description = "Map with names and CIDRs of the created subnets"
  value       = { for item in module.test_subnet : item.subnet_name => item.subnet_address_prefixes }
}

output "test_subnet_name" {
  description = "Names of the created subnet"
  value       = { for item in module.test_subnet : item.subnet_name => item.subnet_name }
}
