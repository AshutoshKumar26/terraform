# Creates EC2 instance with monitoring turned on, tag, security group, keypair.
# Creates a new security group
# Crates a new key pair

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

# Creating a new keypair

resource "aws_key_pair" "mynewkp" {
  key_name   = "mynewkp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCIzTg8UGTfkvKDWt/olOo9wAosixIszc1HK85dnRC/CwU4lG/SyHZnw2KtpIunVsWN8Bec1lr4phFmHC96vDt8E0OiNimR/v8XBV4Exha0jK47gW4Okg3aR63GcBUh0+2JhKaQv1M6OTel95W2YnpBFiDS0ELJsi27MroIOX3Ddy3gQ+La1nF+oVGMiGI41JWrlGvcaHWgluXYI+ImvW/hGtoPvMPTHyq3mhyty+5n5J5zXAyDqfhx2VqGYI/HlWwwyvjGxkuKjrtnFW8D+q7VlJ7qtmB/5pEX+BoNyrzbXZJ48gbYs9PBjGD2PHGy6pXagNPmsQ2IIfTN6/fmq4yR kr.ashutosh26@gmail.com"
}

# Creating a new security group with all traffic allowed

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "All Traffic Allowed"

  ingress {
    description = "Inbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my new sg"
  }
}

# Creating a EC2 instance

resource "aws_instance" "myinstance" {
  ami               = var.ami[var.availability_zone]
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone
  key_name          = "mynewkp"
  security_groups   = ["mysg"]
  monitoring        = "true"
  tags = {
    Name = "ap-south-1b-ec2"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    #private_key = file("C:/Users/ashukuma/Downloads/mykp.pem")
    private_key = https://github.com/AshutoshKumar26/terraform/blob/master/mykp.ppk
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd.service",
      "sudo touch /var/www/html/index.html",
      "sudo chown ec2-user:ec2-user -R /var/www/html/",
      "echo '<!DOCTYPE html><html><body><h1>My First Heading</h1><p>Hi All , I am Ashutosh</p></body></html>' > /var/www/html/index.html"
    ]
  }
}
