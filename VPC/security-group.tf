resource "aws_security_group" "prod-vpc-SG" {
    name = "prod-VPC-Web-SG"
    vpc_id = aws_vpc.prod-vpc.id

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
