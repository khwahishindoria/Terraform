resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_network_interface" "ni-prod-bastion" {
  subnet_id   = aws_subnet.prod-vpc_subnet1.id
  private_ips = ["10.0.0.101"]
  security_groups = [ aws_security_group.prod-vpc-SG.id ]
}

resource "aws_network_interface" "ni-master-node" {
  subnet_id   = aws_subnet.prod-vpc_subnet2.id
  private_ips = ["10.0.1.20"]
  security_groups = [ aws_security_group.prod-vpc-SG.id ]
}

resource "aws_instance" "prod-bastion" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.medium"
  /*subnet_id = aws_subnet.prod-vpc_subnet1.id
  vpc_security_group_ids = [ aws_security_group.prod-vpc-SG.id ]
  
  */
  key_name = aws_key_pair.prod-keypair.key_name

  network_interface {
    network_interface_id = aws_network_interface.ni-prod-bastion.id
    device_index = 0
  }
  root_block_device {
    delete_on_termination = true
    encrypted = false
    iops = 3000
    throughput = 125
    volume_size = 30
    volume_type = "gp3"
    }
  
  tags = {
    Name = "prod-bastion"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "file" {
    source = "/home/ubuntu/.ssh/id_rsa"
    destination = "/home/ubuntu/key.pem" 
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update -y",
      "sudo hostnamectl set-hostname prod-bastion",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]' https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt install fontconfig openjdk-17-jre -y",
      "sudo apt-get install jenkins -y",
      "sudo apt-get install net-tools zip -y",
      "sudo curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "sudo unzip awscliv2.zip",
      "sudo ./aws/install",
      "sudo chmod 600 /home/ubuntu/key.pem",
     ]

    }
    depends_on = [ aws_vpc.prod-vpc, aws_route_table.public-rt ]
}

resource "aws_instance" "master-node" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.medium"
/*subnet_id = aws_subnet.prod-vpc_subnet2.id
  vpc_security_group_ids = [ aws_security_group.prod-vpc-SG.id ]
*/
  key_name = aws_key_pair.prod-keypair.key_name
  tags = {
    Name = "master-01"
  }
  network_interface {
    network_interface_id = aws_network_interface.ni-master-node.id
    device_index = 0
  }
  root_block_device {
    delete_on_termination = true
    encrypted = false
    iops = 3000
    throughput = 125
    volume_size = 30
    volume_type = "gp3"
    }
  connection {
    bastion_host = aws_instance.prod-bastion.public_ip
    bastion_port = "22"
    bastion_private_key = file("~/.ssh/id_rsa")
    type = "ssh"
    bastion_user = "ubuntu"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.private_ip
  }

  provisioner "file" {
    source = "/home/ubuntu/.ssh/id_rsa"
    destination = "/home/ubuntu/key.pem" 
  }

  provisioner "file" {
    source = "/home/ubuntu/Terraform/kubeadm-with-ec2/script-all-nodes.sh"
    destination = "/home/ubuntu/script-all-nodes.sh" 
  }


  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update -y",
      "sudo hostnamectl set-hostname master-01",
      "sudo chmod 600 /home/ubuntu/key.pem",
      "sudo apt-get install net-tools zip -y",
      "sudo curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "sudo apt install fontconfig openjdk-17-jre -y",
      "sudo unzip awscliv2.zip",
      "sudo ./aws/install",
      "sudo chmod +x /home/ubuntu/script-all-nodes.sh",
      "sudo bash /home/ubuntu/script-all-nodes.sh",
      "sudo echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCphMD6/q2Raz6ZAxupdmRMXy99881Pt9xCBT+9OuNGNsChTatZXcr2wLSrrAZkohkHfLB2POuEM9YurfRMDZJTWhUiQDoySC9Tgw0SdJISzv2J4QHE/0VXdxBPLbdBjaZP1d3/9FmXBfpMeKfUWC44tBqY449aaX2rqjx6TTf+W5qfnvG0Hzt2udgfx6gbK5hnzq6y3BDbyocPsSfEbqw3q1Jyjch4A+Hm56m+aBi1R/pStsnJ76VCYDH36Akw+91yzH1fErIgXbIv+HSnvEK7yoiY65XRSV6ROE1JAjvGelKW1Q3yNY7V4g+9wrPPdmb2hcnrv8i0K7hkbCQwtE9jlLxb3fbkkN8FW85O/QUbzLX5DwsgdVH90S506qRSFYmBZkbtBoM5pMpNKkilgjUSoh3/AiNkEqLVsXUolSCKcMTw+KmROGjyo1kV4372A7FUe89Sllr6XmnaWGj+JO6YdVqsYt64J1zmciTIT8F9ZpU1QtX7bEPEos5b8fFhs0M= jenkins@prod-bastion' >> /root/.ssh/authorized_keys",
     ]

    }
    depends_on = [ aws_vpc.prod-vpc, aws_route_table.public-rt ]
}


resource "aws_instance" "worker-nodes" {
  ami                     = "ami-0866a3c8686eaeeba"
  instance_type           = "t2.medium"
  subnet_id = aws_subnet.prod-vpc_subnet2.id
  key_name = aws_key_pair.prod-keypair.key_name
  vpc_security_group_ids = [ aws_security_group.prod-vpc-SG.id ]
  for_each = var.ec2-instance-names
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo hostnamectl set-hostname ${each.value}
EOF
  root_block_device {
    delete_on_termination = true
    encrypted = false
    iops = 3000
    throughput = 125
    volume_size = 30
    volume_type = "gp3"
    }
  connection {
    bastion_host = aws_instance.prod-bastion.public_ip
    bastion_port = "22"
    bastion_private_key = file("~/.ssh/id_rsa")
    type = "ssh"
    bastion_user = "ubuntu"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.private_ip
  }

  provisioner "file" {
    source = "/home/ubuntu/.ssh/id_rsa"
    destination = "/home/ubuntu/key.pem" 
  }

  provisioner "file" {
    source = "/home/ubuntu/Terraform/kubeadm-with-ec2/script-all-nodes.sh"
    destination = "/home/ubuntu/script-all-nodes.sh" 
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update -y",
      "sudo hostnamectl set-hostname ${each.value}",
      "sudo chmod 600 /home/ubuntu/key.pem",
      "sudo chmod +x /root/script-all-nodes.sh",
      "sudo bash /home/ubuntu/script-all-nodes.sh",
      "ssh -i /home/ubuntu/key.pem -o StrictHostKeyChecking=accept-new ubuntu@${aws_instance.master-node.private_ip} 'sudo kubeadm token create --print-join-command;' > /home/ubuntu/kube_join.sh",
      "sudo bash /home/ubuntu/kube_join.sh",
     ]    
  }

  tags = {
    Name = each.value
  }
  depends_on = [ aws_vpc.prod-vpc, aws_route_table.public-rt ]
}
