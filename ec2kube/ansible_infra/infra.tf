terraform {
  required_providers {
    aws = {
	    version = "~> 5.0"
		}
  }

  backend "s3" {
    bucket = "<bucket_name>"
    key    = "<state_file_name>"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}



module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.6.0"
  bucket= var.ansible_bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  force_destroy = true
}