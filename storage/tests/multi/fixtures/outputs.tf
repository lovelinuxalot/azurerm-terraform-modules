output "storage_account_name" {
  value = module.test_storage[*].storage_account_name
}

output "resource_group_name" {
  value = module.test_rg.resource_group_name
}

output "share_id" {
  value = module.test_storage[*].share_id
}

output "share_name" {
  value = module.test_storage[*].share_name
}
output "share_url" {
  value = module.test_storage[*].share_url
}