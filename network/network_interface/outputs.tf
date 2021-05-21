output "network_interface_id" {
  value = azurerm_network_interface.vm_nic.id
}

output "network_interface_private_address" {
  value = azurerm_network_interface.vm_nic.private_ip_address
}

output "network_interface_virtual_machine_id" {
  value = azurerm_network_interface.vm_nic.virtual_machine_id
}

output "network_interface_name" {
  value = azurerm_network_interface.vm_nic.name
}