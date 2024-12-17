provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "webserver" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.prod-keypair.key_name

  provisioner "file" {
    source = "/tmp/dir1"
    destination = "/tmp/dir1"  
      connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("~/.ssh/id_rsa")
  }
  }

    provisioner "file" {
    source = "/tmp/dir2/"
    destination = "/tmp/"  
      connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("~/.ssh/id_rsa")

  }
    
}
}
