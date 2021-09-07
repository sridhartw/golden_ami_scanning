output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "private_subnet_arn" {
  value = aws_subnet.private.arn
}

output "public_subnet_arn" {
  value = aws_subnet.public.arn
}

output "security_group_id" {
  value = aws_security_group.this.id
}