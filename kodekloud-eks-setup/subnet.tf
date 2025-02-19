resource "aws_subnet" "prod-vpc_subnet1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1a"
    tags = {
        type = "private-sub-10.0.0.0"
        Name = "private-sub-10.0.0.0"
    }
    depends_on = [ aws_vpc.prod-vpc ]
}

resource "aws_subnet" "prod-vpc_subnet2" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1b"
    tags = {
        type = "private-sub-10.0.1.0"
        Name = "private-sub-10.0.1.0"
    }
    depends_on = [ aws_vpc.prod-vpc ]
}

resource "aws_subnet" "prod-vpc_subnet3" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1c"
    tags = {
        type = "private-sub-10.0.2.0"
        Name = "private-sub-10.0.2.0"
    }
    depends_on = [ aws_vpc.prod-vpc ]
}