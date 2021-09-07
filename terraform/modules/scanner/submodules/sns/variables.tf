variable "resource-prefix" {}
variable "name" {}
variable "topic_policy_json" {}

variable "sns_email_id" {
  default = ""
}
variable "add_email_subscription" {
  type = bool
  default = false
}

variable "lambda_arn" {
  default = ""
}
variable "add_lambda_subscription" {
  type = bool
  default = false
}