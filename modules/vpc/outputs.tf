output "vpcid" {
  value = aws_vpc.this.id
}
output "vpccidr" {
  value = aws_vpc.this.cidr_block
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
output "route_table_public_id" {
  value = aws_route_table.public.id
}
output "route_table_private_id" {
  value = aws_route_table.private.id
}
