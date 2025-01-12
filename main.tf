
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
   }
 }
}

provider "aws" {
 region  = "us-east-1"
 #shared_credentials_files = ["/Users/user1/.aws/creds"]
}

variable "myhosts" {
  type = list(string)
  #default = ["test1", "test2"]
  default = ["test1"]
}

resource "aws_instance" "test1" {
  for_each = toset(var.myhosts)
  #name = each.value
  ami           = "ami-0e2c8caa4b6378d8c" # ubuntu 24.04
  instance_type = "t2.micro"

 tags = {
    Name = each.value
 }
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.test1[each.key].id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.test1.public_ip
}
