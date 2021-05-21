output "pg_server_name" {
  value = module.test_postgres.server_name
}

output "pg_fqdn" {
  value = module.test_postgres.server_fqdn
}

output "fw_rules" {
  value = module.test_postgres.postgres_firewall_rule_ids
}

output "vnet_rules" {
  value = module.test_postgres.postgres_virtual_network_rule_ids
}

output "pg_server_resource_group_name" {
  value = module.test_rg.resource_group_name
}