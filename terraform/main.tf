terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "personal"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "mini_server" {
  ami           = data.aws_ami.ubuntu.id  #ubuntu 22.04 aws ec2 image
  instance_type = "t2.large"
  vpc_security_group_ids = ["${aws_security_group.rabbit-terraform-sg.id}"]
  subnet_id = aws_subnet.public_subnet[0].id
  root_block_device {
    volume_size = 40
  }
  tags = {
    Name = "rabbit-in-spring"
    Terraformed = true
  }
}
