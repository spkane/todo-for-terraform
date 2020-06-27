package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/plugin"
	"github.com/spkane/todo-for-terraform/terraform-provider-todo/todo"
)

// main is the entrypoint to the terraform plugin
func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: todo.Provider})
}
