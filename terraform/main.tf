terraform {
	required_version = ">= 1.0.0, < 2.0.0"
    backend "s3" {
        bucket = "terraform-latam"
        key    = "terraform/terraform-state.tfstate"
        region = "us-east-1"
        encrypt = true
    }
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "4.20.1"
		}
  	}
}

provider "aws" {
	profile = var.profile
}