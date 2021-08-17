resource "aws_internet_gateway" "bastion-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IG-Bastion"
  }
}