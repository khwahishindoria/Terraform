resource "aws_eks_cluster" "demo-eks" {
  name = "demo-eks"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  compute_config {
    enabled = false
  }
  role_arn = aws_iam_role.eksClusterRole.arn
  version  = var.eks-version

  vpc_config {
    subnet_ids = [
      aws_subnet.prod-vpc_subnet1.id,
      aws_subnet.prod-vpc_subnet2.id,
      aws_subnet.prod-vpc_subnet3.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eksClusterRole_attachment
  ]
}
