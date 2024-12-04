provider "aws" {
    region = "us-east-1" 
}
## VPC Creation  ## 
variable "prod-vpc_cidr-1" {
    default = "10.0.0.0/16"
}
variable "prod-vpc_cidr-2" {
    default = "172.16.0.0/16"
}
resource "aws_vpc" "prod-vpc-1" {
    tags = {
        Name = "PROD-VPC-1"
    }
    cidr_block = var.prod-vpc_cidr-1
}
resource "aws_vpc" "prod-vpc-2" {
    tags = {
        Name = "PROD-VPC-2"
    }
    cidr_block = var.prod-vpc_cidr-2
}

