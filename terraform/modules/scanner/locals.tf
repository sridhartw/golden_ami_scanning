locals {
  golden_ami_parameter =  "arn:aws:ssm:*:${data.aws_caller_identity.this.account_id}:parameter/GoldenAMI/*"
}