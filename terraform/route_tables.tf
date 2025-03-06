resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  # No need to specify Local Target as that is done implicitly to enable traffic among the instances in VPC. 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association_A" {
  subnet_id      = aws_subnet.publicA.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_B" {
  subnet_id      = aws_subnet.publicB.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_C" {
  subnet_id      = aws_subnet.publicC.id
  route_table_id = aws_route_table.public_route_table.id
}
