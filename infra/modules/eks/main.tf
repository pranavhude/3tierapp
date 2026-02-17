# -----------------------
# EKS Cluster
# -----------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role

  vpc_config {
    subnet_ids = concat(var.public_subnets, var.private_subnets)

     endpoint_private_access = true
     endpoint_public_access  = true
  }

  depends_on = []
}

# -----------------------
# EKS Node Group
# -----------------------
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = var.node_role
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  instance_types = ["t3.medium"]

  depends_on = [aws_eks_cluster.this]
}

