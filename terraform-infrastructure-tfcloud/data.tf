data "tfe_workspace" "class" {
  name         = var.workspace_name
  organization = var.org_name
}
