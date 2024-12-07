provider "aws" {
    region = "us-east-1"
}

## VPC Creation  ##
variable "prod-vpc_cidr" {
    default = "10.0.0.0/16"
}
resource "aws_vpc" "prod-vpc" {
    tags = {
        Name = "PROD-VPC"
    }
    cidr_block = var.prod-vpc_cidr
}
resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.prod-vpc.id

}
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "PROD-ELASTIC_IP"
  }
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.master-01.id
  allocation_id = aws_eip.eip.id
}
