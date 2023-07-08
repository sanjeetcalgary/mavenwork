variable "vpc_cidr" {
  type = string
  description = "CIDR block for VPC"
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type = string
  description = "CIDR block for Subnet"
  default = "10.0.1.0/24"
}

variable "aws_region_qa" {
  type = string
  description = "AWS region"
  default = "us-east-1"
}

variable "aws_availzone" {
  type = string
  description = "Availability Zone"
  default = "us-east-1a"
}

variable "ssh_port" {
  type = number
  default = 22
}

variable "nginx_port" {
  type = number
  default = 8080
}

variable "http_port" {
  type = number
  default = 80
}

variable "https_port" {
  type = number
  default = 426
}

variable "own_ip" {
  type = string
  description = "Own IPv4"
  default = "184.64.169.4"
}

variable "instance_type" {
  type = string
  description = "Own IPv4"
  default = "t2.micro"
}

