resource "aws_subnet" "pub-subnets" {
  count                   = length(var.public_subnet_cidr)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Bastion-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "pvt-subnets" {
  count             = length(var.private_subnet_cidr)
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidr, count.index)

  tags = {
    Name = "Bastion-private-subnet-${count.index + 1}"
  }
}