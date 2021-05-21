resource "azurerm_storage_account" "account" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = var.https_only
  allow_blob_public_access  = var.allow_blob_public_access == true ? true : false
  tags                      = var.tags

  dynamic "network_rules" {
    for_each = var.network_rules
    content {
      bypass                     = lookup(network_rules.value, "bypass", [])
      default_action             = lookup(network_rules.value, "default_action", null)
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", [])
      ip_rules                   = lookup(network_rules.value, "ip_rules", [])
    }
  }

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_storage_container" "container" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.account.name
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_storage_queue" "queue" {
  count                = length(var.queues)
  name                 = var.queues[count.index]
  storage_account_name = azurerm_storage_account.account.name
}


resource "azurerm_storage_share" "share" {
  count                = length(var.shares)
  name                 = var.shares[count.index].name
  storage_account_name = azurerm_storage_account.account.name
  quota                = var.shares[count.index].quota
  metadata             = var.shares[count.index].metadata
  lifecycle {
    ignore_changes = [metadata]
  }
}


resource "azurerm_storage_table" "table" {
  count                = length(var.tables)
  name                 = var.tables[count.index]
  storage_account_name = azurerm_storage_account.account.name
}

resource "azurerm_storage_blob" "blob" {
  count                  = length(var.blobs)
  name                   = var.blobs[count.index].name
  storage_account_name   = azurerm_storage_account.account.name
  storage_container_name = var.blobs[count.index].storage_container_name
  type                   = var.blobs[count.index].blob_type
}