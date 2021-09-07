resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.this.id}"
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "${var.resource_prefix}-private-subnet"
    VPC = var.name
    Tier = "private"
  }
  depends_on = [aws_subnet.public]
}


resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${var.resource_prefix}-nat-eip"
    VPC = var.name
    Tier = "private"
  }
}

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public.id


  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.nat
  ]
}


resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "${var.resource_prefix}-private-routetable"
    VPC = var.name
    Tier = "private"
  }
}

resource "aws_route" "private_internet" {
  route_table_id = aws_route_table.private.id
  nat_gateway_id = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
