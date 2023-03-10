terraform {
  required_version = ">= 0.13.5"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.42.0"
    }
  }
  backend "s3" {
    profile        = "spkane-training"
    bucket         = "spkane-training-tfstate"
    key            = "classes/terraform-301-tfcloud.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:us-east-1:929892624845:key/b8c00916-26bd-4388-be96-afce8110cd98"
    acl            = "private"
    dynamodb_table = "tfstate"
  }
}

provider "tfe" {
  hostname = "app.terraform.io"
}

resource "tfe_variable" "gh_token" {
  description = "The token for the GH provider"
  key          = "GITHUB_TOKEN"
  value        = var.github_token
  sensitive    = true
  category     = "env"
  workspace_id = data.tfe_workspace.class.id
}
