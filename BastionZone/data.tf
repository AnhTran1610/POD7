data "aws_availability_zones" "azs" {}

data "aws_ami" "amzn2_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}