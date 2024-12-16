variable "ami" {
    default = "ami-0866a3c8686eaeeba"
  
}

variable "instance_type" {
  default = "t2.micro"
}

variable "webservers" {

    type = list
    #default = ["WEB-1", "WEB-2", "WEB-3"]
    default = ["WEB-1", "WEB-2"]
  
}

output "webserver-1" {
  
  value = var.webservers[0]
}

output "webserver-2" {
  
  value = var.webservers[1]
}

output "webserver-3" {
  
  value = var.webservers[2]
}
