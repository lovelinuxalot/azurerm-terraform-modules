resource "azurerm_key_vault" "key_vault" {
  location            = var.location
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tenant_id           = var.tenant_id

  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  tags = var.tags
}

resource "azurerm_key_vault_key" "encryption_key" {
  name         = var.key_name
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = var.key_type
  key_size = var.key_size
  key_opts = var.key_opts
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  count = length(var.object_id)
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id = azurerm_key_vault.key_vault.tenant_id
  object_id = var.object_id[count.index]
  key_permissions = var.key_permissions
  secret_permissions = var.secret_permissions
  certificate_permissions = var.certificate_permissions
}

resource "azurerm_storage_account_customer_managed_key" "storage_account_managed_key" {
  count = length(var.storage_account_id)
  key_name = azurerm_key_vault_key.encryption_key.name
  key_vault_id = azurerm_key_vault.key_vault.id
  storage_account_id = var.storage_account_id[count.index]
}