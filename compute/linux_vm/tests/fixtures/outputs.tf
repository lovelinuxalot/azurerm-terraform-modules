output "vm_id" {
  value = module.test_vm.virtual_machine_id
}

output "vm_private_ip" {
  value = module.test_vm.virtual_machine_private_ip_address
}

output "vm_resource_group_name" {
  value = module.test_rg.resource_group_name
}

output "vm_vnet" {
  value = module.test_net.virtual_network_name
}

output "vm_subnet" {
  value = module.test_subnet.subnet_name
}

output "vm_name" {
  value = module.test_vm.virtual_machine_name
}

output "nic_name" {
  value = module.test_nic.network_interface_name
}