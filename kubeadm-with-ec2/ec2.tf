resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "master-01" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.prod-vpc_subnet1.id
  key_name = aws_key_pair.prod-keypair.key_name
  
  vpc_security_group_ids = [ aws_security_group.prod-vpc-SG.id ]
  tags = {
    Name = "master-01"
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


        ]

    }
    depends_on = [ aws_vpc.prod-vpc, aws_route_table.public-rt ]
}

resource "aws_instance" "worker-01" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.prod-vpc_subnet2.id
  key_name = aws_key_pair.prod-keypair.key_name
  vpc_security_group_ids = [ aws_security_group.prod-vpc-SG.id ]

  tags = {
    Name = "worker-01"
  }
  user_data = <<EOF
    #!/bin/bash
    sudo apt-get install gnupg
    sudo apt-get install -y python3-pip
    sudo apt-get install -y nginx


  EOF
  depends_on = [ aws_vpc.prod-vpc, aws_route_table.public-rt ]

}
