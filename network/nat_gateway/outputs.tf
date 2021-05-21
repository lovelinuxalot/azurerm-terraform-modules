output "nat_prefix_id" {
  value = var.create_nat_prefix ? azurerm_public_ip_prefix.nat_public_ip_prefix[0].id : var.nat_prefix_id
}
output "nat_prefix_ip_prefix" {
  value = var.create_nat_prefix ? azurerm_public_ip_prefix.nat_public_ip_prefix[0].ip_prefix : "none-get output from data"
}
output "nat_prefix_resource_group_name" {
  value = var.create_nat_prefix ? azurerm_public_ip_prefix.nat_public_ip_prefix[0].resource_group_name : "none-get output from data"
}

output "nat_public_ip_id" {
  value = azurerm_public_ip.nat_public_ip.id
}
output "nat_public_ip_address" {
  value = azurerm_public_ip.nat_public_ip.ip_address
}
output "nat_public_ip_fqdn" {
  value = azurerm_public_ip.nat_public_ip.fqdn
}

output "nat_gateway_id" {
  value = azurerm_nat_gateway.nat-gateway.id
}
output "nat_gateway_resource_guid" {
  value = azurerm_nat_gateway.nat-gateway.resource_guid
}
output "nat_gateway_name" {
  value = azurerm_nat_gateway.nat-gateway.name
}
output "nat_gateway_resource_group" {
  value = azurerm_nat_gateway.nat-gateway.resource_group_name
}

output "nat_gateway_public_association_id" {
  value = azurerm_nat_gateway_public_ip_association.nat-gateway-public-association.id
}