terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.3.0"
  
  backend "s3" {
    bucket         = "2111-tf-state-bucket"   
    key            = "env/dev/terraform.tfstate"   
    region         = "us-east-1"
    dynamodb_table = "winter-Ecomm"
    encrypt        = true                   
  }
}


provider "aws" {
  region = var.region


}
# 