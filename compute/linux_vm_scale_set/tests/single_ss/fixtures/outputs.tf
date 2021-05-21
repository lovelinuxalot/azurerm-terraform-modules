output "virtual_machine_linux_scale_set_name" {
  value = module.test_scaleset.virtual_machine_linux_scale_set_name
}

output "scaleset_resource_group" {
  value = module.test_rg.resource_group_name
}