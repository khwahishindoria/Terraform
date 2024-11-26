provider "aws" {
    region = "us-east-1"  
}
variable "prod-vpc_cidr" {
    default = "10.0.0.0/16" 
}
resource "aws_vpc" "prod-vpc" {
    cidr_block = var.prod-vpc_cidr 
}
output "prod-vpc-id" {
    value = aws_vpc.prod-vpc.id
}
output "prod-igw-id" {
    value = aws_internet_gateway.prod-igw.id
}

resource "aws_subnet" "prod-vpc_subnet1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
  
}
resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.prod-vpc.id
  
}

resource "aws_route_table" "prod-vpc-RT" {
    vpc_id = aws_vpc.prod-vpc.id

        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.prod-igw.id
        }

}

resource "aws_route_table_association" "prod-vpc-RT-ASC" {
    subnet_id = aws_subnet.prod-vpc_subnet1.id
    route_table_id = aws_route_table.prod-vpc-RT.id
  
}

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
    egress {
        description = "Allow all outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
    }

}

resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "Web-Server" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.prod-vpc_subnet1.id
  key_name = aws_key_pair.prod-keypair.key_name
  vpc_security_group_ids = [ aws_security_group.prod-vpc-SG.id ]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }  
  provisioner "remote-exec" {
        inline = [
        "echo 'Hello from the remote instance'",
        "sudo apt update -y",  # Update package lists (for ubuntu)
        "sudo apt-get install -y python3-pip",  # Example package installation
        "sudo apt-get install -y nginx",
        "cd /home/ubuntu",

        ]
    
    }
}
