output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "node_role_arn" {
  value = aws_iam_role.eks_node.arn
}

output "backend_irsa_role_arn" {
  value = aws_iam_role.backend_irsa.arn
}
