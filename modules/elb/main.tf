resource "aws_lb" "this" {
  name                             = var.namelb
  load_balancer_type               = var.typelb
  internal                         = var.internal
  enable_cross_zone_load_balancing = true
  subnets = var.subnet_public_ids
}
resource "aws_lb_listener" "ssh" {
  load_balancer_arn = aws_lb.this.arn
  port              = "22"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
resource "aws_lb_target_group" "this" {
  name     = "bastion-private-subnet"
  port     = 22
  protocol = "TCP"
  vpc_id   = var.vpcid
}