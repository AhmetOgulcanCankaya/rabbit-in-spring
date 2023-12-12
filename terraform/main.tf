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

  user_data = <<-EOF
#!/bin/bash
apt-get update
apt-get upgrade
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo usermod -aG docker ubuntu
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
EOF

  tags = {
    Name = "rabbit-in-spring"
    Terraformed = true
  }
}

resource "aws_ebs_volume" "mini_server_volume" {
 availability_zone = aws_instance.mini_server.availability_zone
 size = 10
 tags= {
    Name = "mini_server volume"
  }
}
resource "aws_volume_attachment" "ebs" {
 device_name = "/dev/sdh"
 volume_id = aws_ebs_volume.mini_server_volume.id
 instance_id = aws_instance.mini_server.id 
}
