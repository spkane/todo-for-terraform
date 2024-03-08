terraform {
  required_version = ">= 1.6.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.42.0"
    }
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
