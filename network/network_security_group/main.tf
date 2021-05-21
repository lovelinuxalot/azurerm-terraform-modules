resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.network_security_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "custom_rules" {
  count                   = length(var.custom_rules)
  name                    = lookup(var.custom_rules[count.index], "name", "default_rule_name")
  priority                = lookup(var.custom_rules[count.index], "priority")
  direction               = lookup(var.custom_rules[count.index], "direction", "Any")
  access                  = lookup(var.custom_rules[count.index], "access", "Allow")
  protocol                = lookup(var.custom_rules[count.index], "protocol", "*")
  source_port_range       = length(lookup(var.custom_rules[count.index], "source_port_ranges", [])) == 0 ? lookup(var.custom_rules[count.index], "source_port_range", "*") : null
  source_port_ranges      = lookup(var.custom_rules[count.index], "source_port_range", null) == null ? lookup(var.custom_rules[count.index], "source_port_ranges", []) : null
  destination_port_range  = length(lookup(var.custom_rules[count.index], "destination_port_ranges", [])) == 0 ? lookup(var.custom_rules[count.index], "destination_port_range", "*") : null
  destination_port_ranges = lookup(var.custom_rules[count.index], "destination_port_range", null) == null ? lookup(var.custom_rules[count.index], "destination_port_ranges", []) : null

  //  source_port_ranges      = split(",", replace(lookup(var.custom_rules[count.index], "source_port_range", "*"), "*", "0-65535"))
  //  destination_port_ranges = split(",", replace(lookup(var.custom_rules[count.index], "destination_port_range", "*"), "*", "0-65535"))
  source_application_security_group_ids      = lookup(var.custom_rules[count.index], "source_application_security_group_ids", [])
  source_address_prefix                      = lookup(var.custom_rules[count.index], "source_application_security_group_ids", null) == null && lookup(var.custom_rules[count.index], "source_address_prefixes", null) == null ? lookup(var.custom_rules[count.index], "source_address_prefix", "*") : null
  source_address_prefixes                    = length(lookup(var.custom_rules[count.index], "source_application_security_group_ids", [])) == 0 ? lookup(var.custom_rules[count.index], "source_address_prefixes", null) : null
  destination_application_security_group_ids = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", [])
  destination_address_prefix                 = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", null) == null && lookup(var.custom_rules[count.index], "destination_address_prefixes", null) == null ? lookup(var.custom_rules[count.index], "destination_address_prefix", "*") : null
  destination_address_prefixes               = length(lookup(var.custom_rules[count.index], "destination_application_security_group_ids", [])) == 0 ? lookup(var.custom_rules[count.index], "destination_address_prefixes", null) : null
  description                                = lookup(var.custom_rules[count.index], "description", "Security rule for ${lookup(var.custom_rules[count.index], "name", "default_rule_name")}")
  network_security_group_name                = azurerm_network_security_group.nsg.name
  resource_group_name                        = var.resource_group_name
}

