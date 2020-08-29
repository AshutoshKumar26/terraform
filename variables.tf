variable "region" {
  #default = "ap-south-1"
}

variable "availability_zone" {
  default = "ap-south-1a"
}

variable "ami" {
  type = "map"
  default = {
    #"ap-south-1a" = "ami-0ebc1ac48dfd14136"
    #"ap-south-1b" = "ami-0a780d5bac870126a"
  }
}
 