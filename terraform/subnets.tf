resource "aws_subnet" "publicA" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.publicA_subnet_cidr_block
  availability_zone       = var.az1a
  map_public_ip_on_launch = true

  tags = {
    Name = "publicA"
  }
}

resource "aws_subnet" "publicB" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.publicB_subnet_cidr_block
  availability_zone       = var.az1b
  map_public_ip_on_launch = true

  tags = {
    Name = "publicB"
  }
}

resource "aws_subnet" "publicC" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.publicC_subnet_cidr_block
  availability_zone       = var.az1c
  map_public_ip_on_launch = true

  tags = {
    Name = "publicC"
  }
}
