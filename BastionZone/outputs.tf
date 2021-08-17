output "Load_Balance_DNS" {
  description = "Load_Balance_DNS"
  value       = aws_lb.NLB-Bastion.dns_name
}