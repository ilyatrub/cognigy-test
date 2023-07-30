terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 5.10.0"
    }
  }

  backend "s3" {
    bucket         = "frolov-test-terraform"
    dynamodb_table = "frolov-test-terraform"
    key            = "test/terraform.tfstate"
    region         = "eu-central-1"
  }
}