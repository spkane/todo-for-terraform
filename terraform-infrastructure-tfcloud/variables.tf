variable "github_token" {
    type = string
    description = "The token required to authenticate against GitHub"
}

variable "org_name" {
  type = string
}

variable "workspace_name" {
  type = string
  default = "terraform-class"
}
