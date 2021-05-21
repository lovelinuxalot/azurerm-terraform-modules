output "virtual_machine_linux_scale_set_id" {
  value = azurerm_linux_virtual_machine_scale_set.linux_vm_scaleset[*].id
}

output "virtual_machine_linux_scale_set_name" {
  value = azurerm_linux_virtual_machine_scale_set.linux_vm_scaleset[*].name
}