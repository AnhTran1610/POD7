# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "public_1" {
  # The VPC ID.
  vpc_id = aws_vpc.nonprod.id

  # The CIDR block for the subnet.
  cidr_block = "10.1.0.0/24"

  # The AZ for the subnet.
  availability_zone = "us-east-1a"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    "Name"                              = "public-AZ1-NonPROD"
    "kubernetes.io/cluster/EKS-NonPROD" = "shared"
    "kubernetes.io/role/elb"            = 1
  }
}

resource "aws_subnet" "public_2" {
  # The VPC ID
  vpc_id = aws_vpc.nonprod.id

  # The CIDR block for the subnet.
  cidr_block = "10.1.1.0/24"

  # The AZ for the subnet.
  availability_zone = "us-east-1b"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    "Name"                              = "public-AZ2-NonPROD"
    "kubernetes.io/cluster/EKS-NonPROD" = "shared"
    "kubernetes.io/role/elb"            = 1
  }
}

resource "aws_subnet" "public_3" {
  # The VPC ID
  vpc_id = aws_vpc.nonprod.id

  # The CIDR block for the subnet.
  cidr_block = "10.1.2.0/24"

  # The AZ for the subnet.
  availability_zone = "us-east-1c"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    "Name"                              = "public-AZ3-NonPROD"
    "kubernetes.io/cluster/EKS-NonPROD" = "shared"
    "kubernetes.io/role/elb"            = 1
  }
}

resource "aws_subnet" "private_1" {
  # The VPC ID
  vpc_id = aws_vpc.nonprod.id

  # The CIDR block for the subnet.
  cidr_block = "10.1.10.0/24"

  # The AZ for the subnet.
  availability_zone = "us-east-1a"

  # A map of tags to assign to the resource.
  tags = {
    "Name"                              = "private-AZ1-NonPROD"
    "kubernetes.io/cluster/EKS-NonPROD" = "shared"
    "kubernetes.io/role/internal-elb"   = 1
  }
}

resource "aws_subnet" "private_2" {
  # The VPC ID
  vpc_id = aws_vpc.nonprod.id

  # The CIDR block for the subnet.
  cidr_block = "10.1.11.0/24"

  # The AZ for the subnet.
  availability_zone = "us-east-1b"

  # A map of tags to assign to the resource.
  tags = {
    "Name"                              = "private-AZ2-NonPROD"
    "kubernetes.io/cluster/EKS-NonPROD" = "shared"
    "kubernetes.io/role/internal-elb"   = 1
  }
}

resource "aws_subnet" "private_3" {
  # The VPC ID
  vpc_id = aws_vpc.nonprod.id

  # The CIDR block for the subnet.
  cidr_block = "10.1.22.0/24"

  # The AZ for the subnet.
  availability_zone = "us-east-1c"

  # A map of tags to assign to the resource.
  tags = {
    "Name"                              = "private-AZ3-NonPROD"
    "kubernetes.io/cluster/EKS-NonPROD" = "shared"
    "kubernetes.io/role/internal-elb"   = 1
  }
}

