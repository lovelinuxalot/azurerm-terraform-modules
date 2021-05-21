output "test_network_security_group_id" {
  value = module.web_ssh_rules.network_security_group_id
}

output "test_network_security_group_name" {
  value = module.web_ssh_rules.network_security_group_name
}

output "test_network_rule" {
  value = module.web_ssh_rules.nsg_rule_name
}

output "resource_group_name" {
  value = azurerm_resource_group.test-nsg.name
}