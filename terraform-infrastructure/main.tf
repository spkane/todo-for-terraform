terraform {
  required_version = "> 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.33.0"
    }
    external = {
      source = "hashicorp/external"
    }
    ns1 = {
      source = "ns1-terraform/ns1"
    }
  }
  backend "s3" {
    profile        = "spkane-training"
    bucket         = "spkane-training-tfstate"
    key            = "classes/terraform-101.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:us-east-1:929892624845:key/b8c00916-26bd-4388-be96-afce8110cd98"
    acl            = "private"
    dynamodb_table = "tfstate"
  }
}

provider "aws" {
  profile = "spkane-training"
  region  = "us-east-1"
}

provider "ns1" {
  apikey = var.personal_ns1_apikey
}
