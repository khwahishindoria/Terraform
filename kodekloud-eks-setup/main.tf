provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}
