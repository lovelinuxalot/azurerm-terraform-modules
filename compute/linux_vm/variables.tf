variable "location" {
  description = "The Azure location to deploy the resource to"
  type        = string
}
variable "resource_group_name" {
  description = "The Azure Resource Group to deploy the resource to"
  type        = string
}

variable "vm_name" {
  description = "The name of the Virtual Machine that is created"
  type        = string
}

variable "vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
}

variable "network_interface_ids" {
  description = "The IDs of the network interfaces that is to be attached to the Virtual Machine"
  type        = list(string)
}

variable "admin_username" {
  description = "The Admin username to be created in the Virtual Machine"
  type        = string
}

variable "disable_password_authentication" {
  description = "The check to enable or disable password based authentication"
  type        = bool
}

variable "image_publisher" {
  type        = string
  description = "The publisher of the image for the Virtual Machine"
}

variable "image_offer" {
  description = "The offering of the image to use"
  type        = string
}

variable "image_sku" {
  description = "The SKU of the image to use"
  type        = string
}

variable "image_version" {
  description = "The version of the image to use"
  type        = string
}

variable "osdisk_name" {
  description = "The OS disk name for the Virtual Machine"
  type        = string
  default     = null
}

variable "osdisk_caching" {
  description = "The OS disk caching to use"
  type        = string
}

variable "storage_account_type" {
  description = "The storage account type to use"
  type        = string
}

variable "disk_size_gb" {
  description = "The Size of the disk to be added on the Virtual Machine"
  type        = number
}

variable "ssh_keys" {
  description = "The SSH keys to be added to the Virtual Machine"
  type        = any
}

variable "custom_data" {
  description = "The Custom data to be passed to the Virtual Machine"
  default     = null
}

variable "availability_set_id" {
  description = "The availability set to attach to the instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags to add to the Virtual Machine"
  type        = map(string)
}

