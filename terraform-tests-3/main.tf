terraform {
  required_providers {
    todo = {
      source  = "spkane/todo"
      version = "2.0.5"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "todo" {
  host = "todo-api.techlabs.sh"
  port = "8080"
  apipath = "/"
  schema = "http"
}

provider "github" {
  token = var.github_token
}

module "simple_github_repo" {
  source  = "github.com/spkane/terraform-github-repository?ref=8b72dcbac2c4287672a22435e36bbc27a869db5c"

  name           = "testing-terraform-ci-cd"
  description    = "Testing Terraform CI/CD. This repo should probably be deleted."
  visibility     = "private"
  auto_init      = true
  default_branch = "main"
  has_issues     = "false"
}
