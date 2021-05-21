provider "azurerm" {
  features {}
}

variable "location" {
  default = ""
}
variable "resource_group_name" {
  default = ""
}
module "test_rg" {
  source              = "../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

variable "hostnames" {
  type = list(string)
}
module "test_storage" {
  source               = "../../../"
  count                = length(var.hostnames)
  storage_account_name = "teststorage1246745${count.index}"
  location             = module.test_rg.location
  resource_group_name  = module.test_rg.resource_group_name

  account_kind             = "FileStorage"
  account_replication_type = "ZRS"
  account_tier             = "Premium"
  https_only               = true
  network_rules = [
    {
      bypass         = ["AzureServices"]
      default_action = "Allow"
    }
  ]

  tags                     = {}
  allow_blob_public_access = true

  shares = [
    {
      name  = "testshare9089088"
      quota = 100
      metadata = {
        azurebackupprotected = true
      }
    }
  ]
}