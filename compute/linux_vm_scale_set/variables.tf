variable "admin_username" {
  description = "The Username of the Admin to use in the Scale Sets"
  type = string
}

variable "instances" {
  description = "The number of instances to be set in the Scale Set"
  type = number
}

variable "location" {
  description = "The Azure location to deploy the resource to"
  type = string
}

variable "scaleset_name" {
  description = "The name of the Scale Set"
  type = string
}

variable "resource_group_name" {
  description = "The Azure Resource Group to deploy the resource to"
  type = string
}

variable "scaleset_sku" {
  description = "The SKU of the Scale Set"
  type = string
}

variable "overprovision" {
  description = "The switch to Overprovision the Scale Sets when deploying the Scale Sets"
  type = bool
}

variable "single_placement_group" {
  description = "The placement Group to set for the instances"
  type = bool
}
variable "upgrade_mode" {
  type = string
}
variable "computer_name_prefix" {
  type = string
}
variable "disable_password_authentication" {
  type = bool
}
variable "osdisk_caching" {
  type = string
}
variable "storage_account_type" {
  type = string
}
variable "disk_size_gb" {
  type = number
}
variable "ssh_keys" {
  type = list(object({
    key      = string
    username = string
  }))
}
variable "custom_data" {
  default = null
}
variable "tags" {
  type = map(string)
}

variable "image_offer" {
  type = string
}
variable "image_publisher" {
  type = string
}
variable "image_sku" {
  type = string
}
variable "image_version" {
  type = string
}
variable "network_interface_name" {
  type = string
}
variable "enable_accelerated_networking" {
  type = bool
}
variable "ip_config_application_gateway_backend_address_pool_ids" {
  type = list(string)
}
variable "ip_config_subnet_id" {
  type = string
}
variable "ip_config_name" {
  type = string
}
variable "eviction_policy" {
  default = null
}
variable "health_probe_id" {
  default = null
}
variable "proximity_placement_group_id" {
  default = null
}
variable "ip_config_application_security_group_ids" {
  type    = list(any)
  default = []
}

variable "zone_balance" {
  type    = bool
  default = false
}
variable "zones" {
  type    = list(string)
  default = []
}