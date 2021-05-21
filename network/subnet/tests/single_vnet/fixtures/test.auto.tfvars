location            = "westus2"
resource_group_name = "my-test-rg"

virtual_network_name = "vnet-t-gwc1-01"
address_space        = ["10.0.1.0/24"]
dns_servers          = ["10.0.1.25"]
tags = {
  "environment" = "t"
  "role"        = "networking"
  "service"     = "jmptest2"
}

network_security_group_name = "terratest-nsg"


//vnets = [
//  {
//    virtual_network_name = "vnet-t-gwc1-01"
//    resource_group_name = "rgp-t-gwc1-jmptest2-networking"
//    address_space = [ "10.0.1.0/24" ]
//    dns_servers = [ "10.0.1.25" ]
//    tags = {
//      "environment" = "t"
//      "role" = "networking"
//      "service" = "jmptest2"
//    }
//  }
//]
//address_prefixes = ["10.0.0.0/16"]

