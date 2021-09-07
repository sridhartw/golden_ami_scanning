variable "resource-prefix" {}
variable "ami_config_bucket" {}
variable "security_group_id" {}
variable "subnet_id" {}

variable "sns_email_id" {}
variable "default_ami" {}
variable "approver_arn" {}
variable "instance_type" {
  default = "t3.large"
}

variable "inspection_frequency" {
  default = "rate(1 day)"
}