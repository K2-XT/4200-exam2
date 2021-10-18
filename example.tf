terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "example" {
  #change the ami for a current one
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  key_name 	= "vockey"

  tags = {
    Name = "Exam2"
  }

  vpc_security_group_ids = [
    aws_security_group.ubuntusg.id
  ]
  provisioner "local-exec" { 
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' -u ec2-user --private-key labsuser.pem  playbook.yml"
}
}

resource "aws_security_group" "ubuntusg" {
  name        = "ubuntu-security-group"
  description = "Allow SSH and 8080 traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
