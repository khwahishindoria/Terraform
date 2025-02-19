variable "prod-vpc_cidr" {
    default = "10.0.0.0/16"
}
variable "eks-version" {
    default = "1.31"
}

variable "coredns-addon-version" {
    default = "v1.11.4-eksbuild.2"
}
variable "pod-identity-agent-addon-version" {
  default = "v1.3.5-eksbuild.2"
}
variable "kube-proxy-addon-version" {
  default = "v1.31.3-eksbuild.2"
}
variable "node-monitoring-agent-addon-version" {
    default = "v1.0.2-eksbuild.2"
  
}