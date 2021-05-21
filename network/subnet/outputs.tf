output "subnet_id" {
  description = "Id of the created subnet"
  value       = azurerm_subnet.subnet.id
}

output "subnet_address_prefixes" {
  description = "CIDR list of the created subnets"
  value       = azurerm_subnet.subnet.address_prefixes
}

output "subnet_name" {
  description = "Name of the created subnet"
  value       = azurerm_subnet.subnet.name
}
