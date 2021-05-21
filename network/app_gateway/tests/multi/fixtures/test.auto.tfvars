//a_hostnames = ["abc.net", "def.net"]
//b_hostnames = ["uvw.net", "xyz.net"]
resource_group_name = "test_rg_appgw"
location            = "westus2"

a_hostnames = {
  "abc.net" = {
    instances = 2
  }
  "def.net" = {
    instances = 2
  }
}

b_hostnames = {
  "uvw.net" = {
    instances = 2
  }
  "xyz.net" = {
    instances = 2
  }
}
