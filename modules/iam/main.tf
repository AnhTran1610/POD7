data "aws_iam_policy_document" "ekscluster" {
    statement {
      actions = ["sts:AssumeRole"]

      principals {
          type = "Service"
          identifiers = ["eks.amazonaws.com"]
      }
    }
}
data "aws_iam_policy_document" "node" {
    statement {
      actions = ["sts:AssumeRole"]

      principals {
          type = "Service"
          identifiers = ["ec2.amazonaws.com"]
      }
    }
}

resource "aws_iam_role" "eks_cluster" {

  name = "eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.ekscluster.json
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role" "nodes_general" {

  name = "eks-node-group-general"
  assume_role_policy = data.aws_iam_policy_document.node.json
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.nodes_general.name
}
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.nodes_general.name
}
