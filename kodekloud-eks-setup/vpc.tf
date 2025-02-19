resource "aws_vpc" "prod-vpc" {
    tags = {
        Name = "PROD-VPC"
    }
    cidr_block = var.prod-vpc_cidr
}