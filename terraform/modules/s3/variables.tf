variable "resource_prefix" {}

variable "name" {
  default = "ami-config-bucket"
}

variable "allowed_role_arn_list" {
  type = list
}