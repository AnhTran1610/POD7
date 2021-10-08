output "cluster_name" {
  value = aws_eks_cluster.this.name
}
output "cluster_id" {
  value = aws_eks_cluster.this.id
  depends_on = [
    aws_eks_cluster.this
  ]
}
output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
output "cluster_identity" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}