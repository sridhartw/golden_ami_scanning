terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.57.0"
    }
  }
}

provider "aws" {
  # TODO : Provide Region
  region = "us-east-1"
}