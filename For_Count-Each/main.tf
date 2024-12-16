provider "aws" {
    region = "us-east-1"
  
}

resource "aws_instance" "webserver" {
    ami = var.ami
    instance_type = var.instance_type
    count = length(var.webservers)
    tags = {
      Name = var.webservers[count.index]
    }
    
}
