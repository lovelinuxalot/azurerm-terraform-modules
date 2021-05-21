output "nat_prefix" {
  value = data.azurerm_public_ip_prefix.test_ngw_prefix.ip_prefix
}
output "nat_prefix_resource_group_name" {
  value = data.azurerm_public_ip_prefix.test_ngw_prefix.resource_group_name
}


output "nat_gw_public_ip" {
  value = module.test_nat_gw.nat_public_ip_address
}

output "nat_gw_id" {
  value = module.test_nat_gw.nat_gateway_id
}

output "nat_gw_name" {
  value = module.test_nat_gw.nat_gateway_name
}

output "nat_gw_resource_group_name" {
  value = module.test_nat_gw.nat_gateway_resource_group
}

output "nat_gw_public_association_id" {
  value = module.test_nat_gw.nat_gateway_public_association_id
}
