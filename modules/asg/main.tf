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
resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "this" {
  key_name = var.key_name
  public_key = tls_private_key.priv_key.public_key_openssh
  provisioner "local-exec" {
    command = "rm -f ~/.ssh/'${var.key_name}'.pem"
  }
  provisioner "local-exec" {
    command = "echo '${tls_private_key.priv_key.private_key_pem}' > ~/.ssh/'${var.key_name}'.pem"
  }
  provisioner "local-exec" {
    command = "chmod 400 ~/.ssh/'${var.key_name}'.pem"
  }
}
#define autoscaling launch configuration
resource "aws_launch_configuration" "this" {
  name            = var.nameec2
  image_id        = data.aws_ami.amzn2_ami.id
  instance_type   = var.instance_type
  security_groups = toset(var.sg_id)
  key_name        = aws_key_pair.this.key_name
  user_data = <<EOF
        #!/bin/bash
        yum update -y
        curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
        chmod +x ./kubectl
        mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
    EOF
  lifecycle {
    create_before_destroy = true
  }
}
#define autoscaling group
resource "aws_autoscaling_group" "custom-group-autoscaling" {
  name                      = "bastion-group-autoscaling"
  vpc_zone_identifier       = var.subnet_id_private
  launch_configuration      = aws_launch_configuration.this.name
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 100
  health_check_type         = "EC2"
  force_delete              = true
  target_group_arns         = var.targetgrouparn
  lifecycle {
    create_before_destroy = true
  }
}