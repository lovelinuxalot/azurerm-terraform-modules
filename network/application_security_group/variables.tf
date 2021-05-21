variable "location" {
  description = "The Azure location to deploy the resource to"
  type = string
}

variable "resource_group_name" {
  description = "The Azure Resource Group to deploy the resource to"
  type = string
}

variable "name" {
  description = "The name of the Application Security Group"
  type = string
}

variable "asg_associate" {
  description = "The option to check the ASG to NIC association"
  type = bool
}

variable "network_interface_id" {
  description = "The ID of the network interface to associate the Application Security Group"
  type    = string
  default = null
}
