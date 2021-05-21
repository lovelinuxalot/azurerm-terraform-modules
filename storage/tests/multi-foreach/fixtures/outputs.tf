//output "storage_account_name" {
//  value = module.test_storage[*].storage_account_name
//}
//
//output "resource_group_name" {
//  value = module.test_rg.resource_group_name
//}
//
//output "share_name" {
//  value = module.test_storage[*].shares
//}

output "storage_account_name" {
  value = module.test_storage["*"].storage_account_name
}