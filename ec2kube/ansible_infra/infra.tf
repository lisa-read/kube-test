terraform {
  required_providers {
    aws = {
	    version = "~> 5.0"
		}
  }

  backend "s3" {
    bucket = "lisaread-terra-bucket"
    key    = "ans_infra/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}



module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  bucket= var.ansible_bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  force_destroy = true
}