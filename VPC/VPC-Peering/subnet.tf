resource "aws_subnet" "prod-vpc_subnet1" {
    vpc_id = aws_vpc.prod-vpc-1.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
        Name = "vpc-1-subnet"
    }
}

resource "aws_subnet" "prod-vpc_subnet2" {
    vpc_id = aws_vpc.prod-vpc-2.id
    cidr_block = "172.16.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1c"
    tags = {
        Name = "vpc-2-subnet"
    }
}
