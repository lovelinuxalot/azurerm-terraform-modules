output "server_id" {
  value = azurerm_postgresql_server.postgres_server.id
}

output "server_fqdn" {
  value = azurerm_postgresql_server.postgres_server.fqdn
}

output "server_name" {
  value = azurerm_postgresql_server.postgres_server.name
}

output "postgres_firewall_rule_ids" {
  value = [azurerm_postgresql_firewall_rule.firewall_rules.*.id]
}

output "postgres_virtual_network_rule_ids" {
  value = [azurerm_postgresql_virtual_network_rule.vnet_rules.*.id]
}

output "server_administrator_login" {
  value = azurerm_postgresql_server.postgres_server.administrator_login
}

output "server_administrator_password" {
  value     = azurerm_postgresql_server.postgres_server.administrator_login_password
  sensitive = true
}