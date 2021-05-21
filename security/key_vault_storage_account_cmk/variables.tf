variable "location" {
  description = "Specifies the supported Azure location where the resource exists"
  type = string
}
variable "key_vault_name" {
  description = "Specifies the name of the Key Vault"
  type = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault"
  type = string
}
variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault"
  type = string
}
variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
  type = string
}
variable "purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault?"
  type = bool
  default = false
}
variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted"
  type = number
  default = 90
}
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  default = {}
}
variable "key_name" {
  description = " Specifies the name of the Key Vault Key."
  type = string
}
variable "key_type" {
  description = "Specifies the Key Type to use for this Key Vault Key."
  type = string
}
variable "key_size" {
  description = "Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048."
  type = number
}
variable "key_opts" {
  description = "A list of JSON web key operations"
  type = list(string)
}
variable "object_id" {
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Changing this forces a new resource to be created"
  type = list(string)
}
variable "storage_account_id" {
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Changing this forces a new resource to be created"
  type = list(string)
}
variable "key_permissions" {
  description = "List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey."
  type = list(string)
  default = []
}
variable "secret_permissions" {
  description = "List of secret permissions, must be one or more from the following: Backup, Delete, get, list, purge, recover, restore and set."
  type = list(string)
  default = []
}
variable "certificate_permissions" {
  description = "(Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update."
  type = list(string)
  default = []
}

