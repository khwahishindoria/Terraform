variable "ec2-instance-names" {
  type = set(string)
  default = [ "worker-01", "worker-02" ]
}
