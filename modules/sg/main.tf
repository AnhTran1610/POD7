resource "aws_security_group" "this" {
  vpc_id      = var.vpcid
  name        = var.namesg
  egress {
    from_port   = var.fport-egress
    to_port     = var.tport-egress
    protocol    = var.ptcegress
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.fport-ingress
    to_port     = var.tport-ingress
    protocol    = "-1"
    cidr_blocks = var.cidringress
  }
  tags = {
    "Name" = "${var.namesg}"
  }
}