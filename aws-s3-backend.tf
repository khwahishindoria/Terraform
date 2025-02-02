provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "s3_backend" {
    bucket = "terraformbackend28012024"
    lifecycle {
      prevent_destroy = true
    }
}
resource "aws_s3_bucket_versioning" "terraform-s3-bv" {
  bucket = "terraformbackend28012024"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_dynamo_DB" {
  name = "terraform_tf_state"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

terraform {
    backend "s3" {
      bucket = "terraformbackend28012024"
      key = "prod/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "dynamodb-s3-lock"
    }

}

