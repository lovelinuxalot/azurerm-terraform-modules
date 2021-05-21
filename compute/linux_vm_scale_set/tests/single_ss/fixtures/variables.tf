variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "jmp_cluster_vm_sku" {
  type    = string
  default = "Standard_D8DS_v4"
}

variable "jmp_cluster_nodes" {
  type    = number
  default = 2
  validation {
    condition     = 1 <= var.jmp_cluster_nodes && var.jmp_cluster_nodes <= 6
    error_message = "Invalid number of nodes for JMP cluster!"
  }
}

variable "jmp_cluster_disk_size" {
  type        = string
  default     = "100"
  description = "Disk size in GB"
}

variable "admin_username" {
  default = ""
}

