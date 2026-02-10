resource "aws_eks_cluster" "this" {
  name     = "prod-eks"
  role_arn = var.cluster_role

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn  = var.node_role
  subnet_ids     = var.subnet_ids

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}
