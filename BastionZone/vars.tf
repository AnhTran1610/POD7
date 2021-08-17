variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.22.0/24"]
}
variable "ssh_key_pair" {
  default = "theanh"
}
variable "instance_type" {
  default = "t2.micro"
}