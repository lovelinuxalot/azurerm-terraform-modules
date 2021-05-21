output "storage_account_name" {
  value = azurerm_storage_account.account.name
}

output "primary_access_key" {
  value = azurerm_storage_account.account.primary_access_key
}
output "storage_account_id" {
  value = azurerm_storage_account.account.id
}

output "container_id" {
  value = azurerm_storage_container.container[*].id
}

output "share_id" {
  value = azurerm_storage_share.share[*].id
}

output "share_url" {
  value = azurerm_storage_share.share[*].url
}

output "share_name" {
  value = azurerm_storage_share.share[*].name
}

output "blob_id" {
  value = azurerm_storage_blob.blob[*].id
}

output "blob_url" {
  value = azurerm_storage_blob.blob[*].id
}

output "queue_id" {
  value = azurerm_storage_queue.queue[*].id
}

output "table_id" {
  value = azurerm_storage_table.table[*].id
}

output "storage_full" {
  value = azurerm_storage_account.account
}
output "principal_id" {
  value = azurerm_storage_account.account.identity.0.principal_id
}