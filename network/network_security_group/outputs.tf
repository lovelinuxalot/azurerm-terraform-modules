output "network_security_group_id" {
  value = azurerm_network_security_group.nsg.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.nsg.name
}

output "nsg_rule_name" {
  value = azurerm_network_security_rule.custom_rules[*].name
}