provider "aws" {
    region = "us-east-1"
}
variable "ami" {
    description = "AMI ID"
}
variable "instance_type" {
    description = "EC2_instance type"
    type = map(string)
    default = {
      "dev" = "t2.micro"
      "stage" = "t2.micro"
      "prod" = "t2.medium"
    }
}
variable "tags" {
    description = "Tags for different VM"
    type = map(string)
    default = {
      "dev" = "DEV-APP"
      "stage" = "STAGE-APP"
      "prod" = "PROD-APP"
        }
  
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami = var.ami
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.medium")
    tags = {
        ENV = lookup(var.tags, terraform.workspace, "default") 
    }
    #tags = lookup(var.tags, terraform.workspace, "default")  
  
}
