output "nic_id" {
  value = module.test_nic.network_interface_id
}

output "nic_private_ip_address" {
  value = module.test_nic.network_interface_private_address
}

output "subnet_name" {
  value = module.test_subnet.subnet_name
}

output "resource_group_name" {
  value = module.test_rg.resource_group_name
}

output "vnet_name" {
  value = module.test_net.virtual_network_name
}