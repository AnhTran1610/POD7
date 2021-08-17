# Resource: aws_route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

resource "aws_route_table" "public" {
  # The VPC ID.
  vpc_id = aws_vpc.nonprod.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC internet gateway or a virtual private gateway.
    gateway_id = aws_internet_gateway.nonprod.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "public-rt-NonPROD"
  }
}

resource "aws_route_table" "private1" {
  # The VPC ID.
  vpc_id = aws_vpc.nonprod.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw1.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "private1-rt-NonPROD"
  }
}

resource "aws_route_table" "private2" {
  # The VPC ID.
  vpc_id = aws_vpc.nonprod.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw2.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "private2-rt-NonPROD"
  }
}

resource "aws_route_table" "private3" {
  # The VPC ID.
  vpc_id = aws_vpc.nonprod.id

  route {
    # The CIDR block of the route.
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw3.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "private3-rt-NonPROD"
  }
}
