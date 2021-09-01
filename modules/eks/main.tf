resource "aws_eks_cluster" "this" {
  
  name = var.namecluster
  role_arn = var.iam_role_cluster_arn
  version = var.k8sversion

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    # public_access_cidrs = ["0.0.0.0/0"]
    security_group_ids = var.sg_id
    subnet_ids = var.allsubnetid
  }
}

resource "aws_eks_node_group" "nodes_general" {
  
  cluster_name = aws_eks_cluster.this.name
  node_group_name = var.namenodegroup
  node_role_arn = var.iam_role_node_arn
  subnet_ids = var.allsubnetprivateid

  scaling_config {
    desired_size = 3
    max_size = 3
    min_size = 1
  }

  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 20
  force_update_version = false
  instance_types = ["t3.small"]
  labels = {
    role = "nodes-general"
  }
  version = var.k8sversion
}
