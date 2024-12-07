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
        description = "Kubernetes API server"
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    #
    ingress {
        description = "etcd server"
        from_port = 2379
        to_port = 2380
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    ingress {
        description = "Kubelet API"
        from_port = 10250
        to_port = 10250
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    ingress {
        description = "Kube-Scheduler"
        from_port = 10259
        to_port = 10259
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    ingress {
        description = "Kube-Controller-Manager"
        from_port = 10257
        to_port = 10257
        protocol = "tcp"
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