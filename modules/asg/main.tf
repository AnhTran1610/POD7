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
resource "aws_key_pair" "this" {
  key_name = var.ssh_key_pair
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDN2YetFCpDOsQy7Hx8uCkJGZkFMVYtCmIKwP+Px7H5zPqkt68lF/QvvUn+qpfjoGzDVQTyqWXn7HtpEVJhqUg0T1l5EfGi8H5KvpAevavKtwyyKQYe2j2xLur81hY+rYmphJZ63TWBC+BX9G/qrL+p0Brd4iUrVppbJlmRWdK5LenHv9fNxhB7QlkRhw0ZgMvP2im8XpRbeCVNOSLGTjGrVcXLaEJR4GXCyL7xb3U22FVSIQmofr1ZnDi5X4rVYyan57R6swIIR0ivhKevGjkZ5fWNZpuM5rJAAaMNWZCUayrS1TFbqpEqfa0QMlhO/s7RWlV/6wBzKUbbTDH7yhxp2GkkfK9xWzp5/WRrCb1ckW0ipt4uBrmhMvRKPKQi8NPzJOJaayrL62iwKONsZWCG76InBZkxWBw9PPx840QLFMRytteGcvxg4ZgwZ/seN3kfLDcKz39Fmu2Cj6/1LlXDr3+HPq80DcPJWc3gSWJxSfs93CcKB1Yww6hK/45+isw5hkptQrgYf2rNO+UVW4VYwKrRkuY1VCRiyXeYsz212E0kelceN4pyCeCXneB0ROIwcxVPnukNrKuZLmFtb21JmsD0Ui1Qbn5NxeJkoWAh6E+NiM1EOKDrROluTZ3ydercD5tTq4gCvUmyQ4hpJQ51ZxVn9E3Kg1jf6S4AbTyV2w== ahta@VNPC014167"
}
#define autoscaling launch configuration
resource "aws_launch_configuration" "this" {
  name            = var.nameec2
  image_id        = data.aws_ami.amzn2_ami.id
  instance_type   = var.instance_type
  security_groups = toset(var.sg_id)
  key_name        = aws_key_pair.this.key_name
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
}