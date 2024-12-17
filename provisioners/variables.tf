variable "ami" {
    default = "ami-0866a3c8686eaeeba" 
}
variable "instance_type" {
  default = "t2.micro"
}
output "public-public_ip" {
  value = aws_instance.webserver.public_ip
}
