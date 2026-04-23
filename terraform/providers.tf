provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "s3" {
    bucket = "dee-store-state-bucket"
    key    = "terraform/terraform.tfstate"
    region = "eu-central-1"    
  }
}