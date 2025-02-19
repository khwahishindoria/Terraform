resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.demo-eks.name
  addon_name                  = "coredns"
  addon_version               = var.coredns-addon-version 
  resolve_conflicts_on_update = "PRESERVE"
}


resource "aws_eks_addon" "pod-identity-agent" {
  cluster_name                = aws_eks_cluster.demo-eks.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = var.pod-identity-agent-addon-version 
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = aws_eks_cluster.demo-eks.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube-proxy-addon-version 
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "node-monitoring-agent" {
  cluster_name                = aws_eks_cluster.demo-eks.name
  addon_name                  = "eks-node-monitoring-agent"
  addon_version               = var.node-monitoring-agent-addon-version
  resolve_conflicts_on_update = "PRESERVE"
}