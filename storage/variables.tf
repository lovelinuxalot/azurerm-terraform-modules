variable "storage_account_name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "account_tier" {
  type = string
}
variable "account_kind" {
  type = string
}
variable "account_replication_type" {
  type = string
}
variable "allow_blob_public_access" {
  type = bool
}
variable "https_only" {
  type = bool
}
variable "tags" {
  type = map(string)
}
variable "access_tier" {
  type    = string
  default = "Hot"
}
variable "network_rules" {
  type    = any
  default = []
}
variable "containers" {
  type    = any
  default = []
}
variable "queues" {
  type    = any
  default = []
}
variable "shares" {
  type    = any
  default = []
}
variable "tables" {
  type    = any
  default = []
}
variable "blobs" {
  type    = any
  default = []
}
