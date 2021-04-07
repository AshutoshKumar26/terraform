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
