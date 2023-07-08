terraform {
  required_version = "~> v1.3.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region_qa
  profile = "default"
}