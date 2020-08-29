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
    private_key = "MIIEowIBAAKCAQEAiM04PFBk35Lyg1rf6JTqPcAKLIsSLM3NRyvOXZ0QvwsFOJRv0sh2Z8NiraSLp1bFjfAXnNZa+KYRZhwverw7fBNDojYpkf7/FwVeBMYWtIyuO4FuDpIN2ketxnAVIdPtiYSmkL9TOjk3pfeVtmJ6QRYg0tBCybItuzK6CDl9w3ct4EPi2tZxfqFRjIhiONSVq5Rr3Gh1oJbl2CPiJr1v4RraD7zD0x8qt5ocrcvuZ+Sec1wMg6n4cdlahmCPx5VsMMr4xsZLio67ZxVvA/qu1ZSe6rZgf+aRF/gaDcq8212SePIG2LPTwYxg9jxxsuqV2oDT5rENiCH0zev35quMkQIDAQABAoIBAEwDM68XwKUV4pioIuf57pn3HfAYKjYo+FoGdjk/77Enb3Q7zlKhvmDziN4RIuQNa+HtOUGVPaERrXM+UAdzld3gWmFElR6hQJ5LBi3C35Tc4mcACOYhs37I+z7awnM0bbVOtrqRBK7CYjBe/JoF6AZIRF6/B41I6u4sRoARadb0iJPvRMG+L1q+GAVKpYiFsax8q/t/eb2dPVP4ubHlrGZbcANAwVevvtQMN8cbM1L9sDaAe+QHLWdJQ0PkMOyxLghPMuZNKe4kJHvVU22NQzi/Fywn/k9sCUcZ4IGpkAl3eXiTw+Us3zZCP5s2ZUfB4M6YTnh28ZyJa0s4OQlZP80CgYEA7xrAiXKE7kiR1HdWxLP54Wni/qXIZTefCAvMW0jse0+L39QjSHV04Ts+pFH3Pb/v65TrXAc7KxGqMypCn2Cp/lHwK6JlZWbTMHXGUQxdpVle2FCV4YbHjszMJECucoOg8zDOR/WVPGNnQ+eWtQ2+kgOkjyx63EQ+e2ek8gfO54sCgYEAknffwv31/MTEjLqgtKkn72KgY7NUFNhqg2A/RoJC04qFxcM2EpDF7sVtcoAZXu4fdhCCrwGTKKMHSEfTMIuS3cWQ3ySBLe9/p/20U7+FzeQnjCjLRGVKVl9P0PeFvlpMl2hiiPBYPf5ZmdhBeHdtGG1S/7Uwdl/anhXAWmVmv9MCgYEAzwreP+Z/Pwpt5Im2A7xImy0iVxjc7vB77+6vdTgvNhPKbfX2226B1+qCMq2bJshGCzu3lcfZL1ErjQSCDhoY+VSgYFhN7sFcDDFfmZzYli5OF4eoUVJxCLFD7/xmUliyjQLtDJiWMmVs7PrjoEGXjD5FR4jflk4twJQd20pxmkMCgYApfjgvv05ei0e7Lmu0gm9Dy8bwN69MMHsMOMn0KZbQ4t8+xSyeWdEY8WkuFMgbMo5LHiZHecS8sGKxwVc8222B0iRWcrr9zml1p9PcHdfEGixx8mSTPbavfVTZOCX1ZRNpmTLA5IW7GkE76h2yCPMpBl+K/UN7ZXBDdJoHgc537QKBgB1f2gWt9GFc2UyHK9iqhlyOW3x9sr72cI+qdMbA9YgKhP2owF50jqFCMc1Nc2DnaFDQRwSJPR0xuJe+zGaLdubV54tCYeRvwN+eYGFMPaJLk5xcAE2F+pILaZwzs9FbT5r8ZtXU/iZtDoYnEtWoipqVM5Qaxa3CfEI9+zjIoXVO"
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
