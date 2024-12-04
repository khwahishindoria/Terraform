
resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "APP-VPC-1" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.prod-vpc_subnet1.id
  key_name = aws_key_pair.prod-keypair.key_name
  vpc_security_group_ids = [ aws_security_group.prod-vpc-1-SG.id ]
  tags = {
    Name = "APP-VPC-1"
  }

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
        "sudo apt-get install -y nginx",

        ]
    
    }
}

resource "aws_instance" "APP-VPC-2" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.prod-vpc_subnet2.id
  key_name = aws_key_pair.prod-keypair.key_name
  vpc_security_group_ids = [ aws_security_group.prod-vpc-2-SG.id ]
  tags = {
    Name = "APP-VPC-2"
  }

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
        "sudo apt-get install -y net-tools",

        ]
    
    }
}
