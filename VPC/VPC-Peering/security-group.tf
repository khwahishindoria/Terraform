resource "aws_security_group" "prod-vpc-1-SG" {
    name = "prod-VPC-1-Web-SG"
    vpc_id = aws_vpc.prod-vpc-1.id

    ingress {
        description = "Allow HTTP Traffic"
        from_port = 80
        to_port = 80
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
    }
    ingress {
        description = "Allow SSH Traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    ingress {
        description = "Allow ICMP Traffic"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    egress {
        description = "Allow all outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
    }

}


resource "aws_security_group" "prod-vpc-2-SG" {
    name = "prod-VPC-2-Web-SG"
    vpc_id = aws_vpc.prod-vpc-2.id

    ingress {
        description = "Allow HTTP Traffic"
        from_port = 80
        to_port = 80
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
    }
    ingress {
        description = "Allow SSH Traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    ingress {
        description = "Allow ICMP Traffic"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    egress {
        description = "Allow all outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
    }

}
