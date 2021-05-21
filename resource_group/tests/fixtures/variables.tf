variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "rg_tags" {
  type    = map(string)
  default = {}
}