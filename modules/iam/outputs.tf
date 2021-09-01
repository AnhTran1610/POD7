output "iam_role_cluster_arn" {
    value = aws_iam_role.eks_cluster.arn
}
output "iam_role_node_arn" {
    value = aws_iam_role.nodes_general.arn
}
