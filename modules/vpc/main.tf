resource "aws_vpc" "this" {
    cidr_block = var.cidr
    instance_tenancy = "default"
    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = {
      "Name" = join("-", ["VPC", var.name])
    }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = join("-", ["IGW", var.name])
  }
}
resource "aws_eip" "this" {
  depends_on = [aws_internet_gateway.this]
  tags = {
    "Name" = join("-", ["EIP", var.name])
  }
}
resource "aws_subnet" "public" {
  for_each                = var.subnet_tier1
  
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.cidr, 8, each.value)
  map_public_ip_on_launch = true
  tags = {
    "Name" = join("-", [var.name,"Public", trimprefix(each.key, "us-east-")])
    "Tier" = "Public"
    "kubernetes.io/cluster/${var.namecluster}" = "shared"
    "kubernetes.io/role/elb"            = 1
  }
}
resource "aws_subnet" "private" {
  for_each                = var.subnet_tier2

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.cidr, 8, each.value)
  tags = {
    "Name" = join("-", [var.name,"Private", trimprefix(each.key, "us-east-")])
    "Tier" = "Private"
    "kubernetes.io/cluster/${var.namecluster}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}
resource "aws_subnet" "db" {
  for_each                = var.subnet_tier3

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.cidr, 8, each.value)
  tags = {
    "Name" = join("-", [var.name,"DB", trimprefix(each.key, "us-east-")])
    "Tier" = "Database"
  }
}
data "aws_subnet_ids" "all" {
  vpc_id = aws_vpc.this.id
   filter {
    name = "tag:Tier"
    values = ["Public", "Private"]
 }
 depends_on = [aws_subnet.public, aws_subnet.private]
}
data "aws_subnet_ids" "public" {
  vpc_id = aws_vpc.this.id
   filter {
    name = "tag:Tier"
    values = ["Public"]
 }
 depends_on = [aws_subnet.public]
}
data "aws_subnet_ids" "private" {
  vpc_id = aws_vpc.this.id
   filter {
    name = "tag:Tier"
    values = ["Private"]
 }
 depends_on = [aws_subnet.private]
}
data "aws_subnet" "public" {
 filter {
   name = "tag:Name"
   values = [join("-", [var.name, "Public-1a"])]
 }
 depends_on = [aws_subnet.public]
}
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id = data.aws_subnet.public.id
  tags = {
    "Name" = join("-", ["NatGateway", var.name])
  }
  depends_on = [aws_eip.this, aws_subnet.public]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
    }
  depends_on = [aws_internet_gateway.this]
  tags = {
    "Name" = join("-",["Public-Route-Table",var.name])
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
    }
  depends_on = [aws_nat_gateway.this]
  tags = {
    "Name" = join("-",["Private-Route-Table",var.name])
  }
}
resource "aws_route_table_association" "public" {
  for_each = var.subnet_tier1

  subnet_id = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  for_each = var.subnet_tier2
  
  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}