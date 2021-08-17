output "vpcid" {
  value = aws_vpc.this.id
}

output "subnet_id_all" {
  value = [for s in data.aws_subnet_ids.all.ids: s]
}
output "subnet_id_public" {
  value = [for s in data.aws_subnet_ids.public.ids: s]
}
output "subnet_id_private" {
  value = [for s in data.aws_subnet_ids.private.ids: s]
}
