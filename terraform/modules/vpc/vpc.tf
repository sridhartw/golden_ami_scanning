resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags = {
    Name = "${var.resource_prefix}-${var.name}"
  }
  enable_dns_support = true
  enable_dns_hostnames = true
}


