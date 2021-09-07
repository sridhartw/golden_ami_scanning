resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "${var.resource_prefix}-public-subnet"
    VPC = var.name
    Tier = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.this.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.this.id}"
}

resource "aws_route" "internet" {
  route_table_id = "${aws_route_table.public.id}"
  gateway_id = "${aws_internet_gateway.igw.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}