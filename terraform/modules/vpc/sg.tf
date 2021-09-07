resource "aws_security_group" "this" {
  name = "${var.resource_prefix}-${var.name}-sg"
  vpc_id = aws_vpc.this.id
}

resource "aws_security_group_rule" "ingress" {
  type = "ingress"

  security_group_id = "${aws_security_group.this.id}"

  protocol = "tcp"
  from_port = 1
  to_port = 65525

  cidr_blocks = ["0.0.0.0/0"]
}

