#define autoscaling launch configuration
resource "aws_launch_configuration" "custom-launch-config" {
  name            = "custom-launch-config"
  image_id        = data.aws_ami.amzn2_ami.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.allow-ssh.id]
  key_name        = var.ssh_key_pair
  connection {
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("theanh.pem")
    agent       = false
  }
}
#define autoscaling group
resource "aws_autoscaling_group" "custom-group-autoscaling" {
  name                      = "custom-group-autoscaling"
  vpc_zone_identifier       = [aws_subnet.pvt-subnets[0].id, aws_subnet.pvt-subnets[1].id, aws_subnet.pvt-subnets[2].id]
  launch_configuration      = aws_launch_configuration.custom-launch-config.name
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 100
  health_check_type         = "EC2"
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.group-bastion.arn]
  tags = [{
    "Name" = "Bastion-host"
  }]
}

