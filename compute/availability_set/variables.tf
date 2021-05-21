variable "location" {
  description = "The location to deploy the resource"
  type        = string
}
variable "name" {
  description = "The name of the availability set"
  type        = string
}
variable "resource_group_name" {
  description = "The resource group to deploy the resource"
  type        = string
}
variable "platform_update_domain_count" {
  description = "The number of update domains that are used"
  type        = number
  default     = 5
}
variable "platform_fault_domain_count" {
  description = "The number of fault domains that are used"
  type        = number
  default     = 3
}
variable "proximity_placement_group_id" {
  description = "The ID of the Proximity Placement Group to which this Virtual Machine should be assigned."
  default     = null
}
variable "managed" {
  description = "Specifies whether the availability set is managed or not"
  type        = bool
  default     = true
}
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}