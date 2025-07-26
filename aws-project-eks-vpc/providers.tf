terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.94.1"
    }
  }

  backend "s3" {
    bucket = "akshaydurgade-tf-state-bucket"
    key    = "aws-projects/vpc"
    region = "us-east-1"
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}