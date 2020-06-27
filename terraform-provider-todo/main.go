package main

import (
	// Upstream Terraform Plugin Library
	"github.com/hashicorp/terraform-plugin-sdk/plugin"
	// Our local Terraform Provider code
	"github.com/spkane/todo-for-terraform/terraform-provider-todo/todo"
)

// main is the entrypoint to the terraform plugin
func main() {
	// see: https://github.com/hashicorp/terraform/blob/master/plugin/serve.go
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: todo.Provider})
}
