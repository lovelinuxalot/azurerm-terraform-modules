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

module "test_storage" {
  source               = "../../../"
  storage_account_name = "teststorage1246745"
  location             = module.test_rg.location
  resource_group_name  = module.test_rg.resource_group_name

  access_tier              = "Hot"
  account_kind             = "BlobStorage"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  enable_blob_encryption   = false
  enable_file_encryption   = false
  https_only               = false
  //  network_rules = ""

  //  containers = ""
  //  queues = ""
  //  shares = ""
  //  tables = ""
  //  blobs = ""

  tags = {}

}