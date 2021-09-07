variable "resource-prefix" {}
variable "name" {}
variable "policy_json" {}
variable "file_path" {}

variable "additional_policy_arn" {
  type = list
  default = []
}

variable "variables" {
  type = map
  default = {
    terraform = true
  }
}

