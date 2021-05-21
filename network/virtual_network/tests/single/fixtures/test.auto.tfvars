virtual_network_name = "vnet-t-gwc1-01"
resource_group_name  = "rgp-t-gwc1-jmptest2-networking"
address_space        = ["44.138.81.128/26"]
dns_servers          = ["44.138.68.4"]
tags = {
  "environment" = "t"
  "role"        = "networking"
  "service"     = "jmptest2"
}

location = "westus2"