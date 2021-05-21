resource "azurerm_postgresql_server" "postgres_server" {
  name                = var.server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku_name

  storage_mb                   = var.storage_mb
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  administrator_login              = var.administrator_login
  administrator_login_password     = var.administrator_password
  version                          = var.server_version
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

  auto_grow_enabled             = var.auto_grow_enabled
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

resource "azurerm_postgresql_virtual_network_rule" "vnet_rules" {
  count                                = length(var.vnet_rules)
  name                                 = format("%s%s", var.vnet_rule_name_prefix, lookup(var.vnet_rules[count.index], "name", count.index))
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.postgres_server.name
  subnet_id                            = var.vnet_rules[count.index]["subnet_id"]
  ignore_missing_vnet_service_endpoint = var.vnet_rule_ignore_missing_vnet_service_endpoint
}

resource "azurerm_postgresql_firewall_rule" "firewall_rules" {
  count               = length(var.firewall_rules)
  name                = format("%s%s", var.firewall_rule_prefix, lookup(var.firewall_rules[count.index], "name", count.index))
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres_server.name
  start_ip_address    = var.firewall_rules[count.index]["start_ip"]
  end_ip_address      = var.firewall_rules[count.index]["end_ip"]
}