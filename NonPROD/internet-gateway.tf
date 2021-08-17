# Resource: aws_internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "nonprod" {
  # The VPC ID to create in.
  vpc_id = aws_vpc.nonprod.id
  # A map of tags to assign to the resource.
  tags = {
    Name = "IG-NonPROD"
  }
}
