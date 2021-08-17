resource "aws_lb" "NLB-Bastion" {
  name                             = "NLBforBastionhost-THEANH"
  load_balancer_type               = "network"
  internal                         = false
  enable_cross_zone_load_balancing = true
  subnet_mapping {
    subnet_id = aws_subnet.pub-subnets[0].id
  }
  subnet_mapping {
    subnet_id = aws_subnet.pub-subnets[1].id
  }
  subnet_mapping {
    subnet_id = aws_subnet.pub-subnets[2].id
  }
  tags = {
    Environment = "Bastion"
  }
  depends_on = [aws_nat_gateway.gw1]

}

resource "aws_lb_listener" "ssh" {
  load_balancer_arn = aws_lb.NLB-Bastion.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group-bastion.arn
  }
}

resource "aws_lb_target_group" "group-bastion" {
  name     = "bastion-private-subnet"
  port     = 22
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

