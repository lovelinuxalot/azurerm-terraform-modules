resource_group_name = "test_rg_vm"
location            = "westus2"

administrator_login    = "testuser123"
administrator_password = "653b^TEFKUoqLs$&80RQCs0ejmBs"
server_name            = "test-postgres-name"
sku_name               = "GP_Gen5_8"
server_version         = "11"
storage_mb             = 102400

vnet_rule_name_prefix = "vnet-rule-"
fw_rule_prefix        = "firewall-"
fw_rules = [
  { name = "test1", start_ip = "10.0.1.5", end_ip = "10.0.1.8" },
  { name = "test2", start_ip = "10.0.1.129", end_ip = "10.0.1.156" }
]

