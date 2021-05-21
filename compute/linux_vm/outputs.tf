output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.linux_vm.id
}
output "virtual_machine_private_ip_address" {
  value = azurerm_linux_virtual_machine.linux_vm.private_ip_address
}
output "virtual_machine_public_ip_address" {
  value = azurerm_linux_virtual_machine.linux_vm.public_ip_address
}
output "virtual_machine_unique_id" {
  value = azurerm_linux_virtual_machine.linux_vm.virtual_machine_id
}
output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}