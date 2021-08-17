data "aws_vpc" "nonprodvpc" {
  filter {
    name  = "tag:Name"
    values = ["VPC for NonPROD"]
  }
}
data "aws_internet_gateway" "nonprodigw" {
  filter {
    name  = "tag:Name"
    values = ["IG-NonPROD"]
  }
}
resource "aws_vpc_peering_connection" "bastion2nonprod" {
  peer_vpc_id = data.aws_vpc.nonprodvpc.id
  vpc_id      = aws_vpc.main.id
}
resource "aws_vpc_peering_connection_accepter" "accept_peering" {
  vpc_peering_connection_id = aws_vpc_peering_connection.bastion2nonprod.id
  auto_accept               = true
}
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table" "route2bastion" {
  route  {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.bastion2nonprod.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "nonprod->bastion"
  }
}
resource "aws_main_route_table_association" "set-worker-default-rt-assoc" {
  vpc_id         = data.aws_vpc.nonprodvpc.id
  route_table_id = aws_route_table.route2bastion.id
}