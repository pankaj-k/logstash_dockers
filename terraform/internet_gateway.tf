resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "logstash_ecs_fargate_igw"
  }
}
