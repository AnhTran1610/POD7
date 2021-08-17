# Resource: aws_nat_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "gw1" {
  # The Allocation ID of the Elastic IP address for the gateway.
  allocation_id = aws_eip.nat1.id
  # The Subnet ID of the subnet in which to place the gateway.
  subnet_id = aws_subnet.pub-subnets[0].id
  # A map of tags to assign to the resource.
  tags = {
    Name = "NAT-Bastion"
  }
  depends_on = [
    aws_eip.nat1
  ]
}
# resource "aws_nat_gateway" "gw2" {
#   # The Allocation ID of the Elastic IP address for the gateway.
#   allocation_id = aws_eip.nat1.id
#   # The Subnet ID of the subnet in which to place the gateway.
#   subnet_id = aws_subnet.pub-subnets[1].id
#   # A map of tags to assign to the resource.
#   tags = {
#     Name = "NAT2-Bastion"
#   }
#   depends_on = [
#     aws_eip.nat1
#   ]
# }
# resource "aws_nat_gateway" "gw3" {
#   # The Allocation ID of the Elastic IP address for the gateway.
#   allocation_id = aws_eip.nat1.id
#   # The Subnet ID of the subnet in which to place the gateway.
#   subnet_id = aws_subnet.pub-subnets[2].id
#   # A map of tags to assign to the resource.
#   tags = {
#     Name = "NAT3-Bastion"
#   }
#   depends_on = [
#     aws_eip.nat1
#   ]
# }