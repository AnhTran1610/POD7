# Resource: aws_route_table_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "public1" {
  # The subnet ID to create an association.
  subnet_id = aws_subnet.pub-subnets[0].id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  # The subnet ID to create an association.
  subnet_id = aws_subnet.pub-subnets[1].id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public3" {
  # The subnet ID to create an association.
  subnet_id = aws_subnet.pub-subnets[2].id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  # The subnet ID to create an association.
  subnet_id = aws_subnet.pvt-subnets[0].id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  # The subnet ID to create an association.
  subnet_id = aws_subnet.pvt-subnets[1].id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.private2.id
}

resource "aws_route_table_association" "private3" {
  # The subnet ID to create an association.
  subnet_id = aws_subnet.pvt-subnets[2].id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.private3.id
}