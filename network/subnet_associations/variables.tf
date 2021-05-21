variable "subnet_id" {
  default = ""
}
variable "subnet_nsg_associations" {
  type    = any
  default = []
}
variable "subnet_nat_associations" {
  type    = any
  default = []
}