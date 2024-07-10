terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.56"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "terraform-testing-lt"
    key    = "terraform-testing/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}