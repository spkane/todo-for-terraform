package todo

import (
	// OpenAPI Libraries
	"github.com/go-openapi/runtime"
	httptransport "github.com/go-openapi/runtime/client"
	strfmt "github.com/go-openapi/strfmt"

	// Terraform Libraries
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"

	// Todo API Libraries
	"github.com/spkane/todo-for-terraform/client"
	"github.com/spkane/todo-for-terraform/client/todos"
)

// Provider returns the provider schema.
// - provider, resources, data source, and configuration.
func Provider() *schema.Provider {

	// The actual provider
	provider := &schema.Provider{
		Schema: map[string]*schema.Schema{
			// Todo server host name/IP
			"host": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The FQDN or IP address for the todo server",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_HOST", "127.0.0.1"),
			},
			// Todo server listening port
			"port": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The port for the todo server",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_PORT", "8080"),
			},
			// Todo server listening protocol
			"schema": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The URL schema for the todo server",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_SCHEMA", "http"),
			},
			// Todo server API URL path
			"apipath": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The URL path for the todo server API",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_APIPATH", "/"),
			},
		},
		// All the Data Sources that Todo provides
		DataSourcesMap: map[string]*schema.Resource{
			"todo": dataSourceTodo(),
		},
		// All the Resources that Todo provides
		ResourcesMap: map[string]*schema.Resource{
			"todo": resourceTodo(),
		},
	}

	provider.ConfigureFunc = func(d *schema.ResourceData) (interface{}, error) {
		terraformVersion := provider.TerraformVersion
		// Determine if we are being run by a pre-0.12 release of Terraform
		if terraformVersion == "" {
			// Terraform 0.12 introduced this field to the protocol
			// We can therefore assume that if it's missing it's 0.10 or 0.11
			terraformVersion = "0.11+compatible"
		}
		return providerConfigure(d, terraformVersion)
	}

	return provider

}

// providerConfigure sets up the provider.
// Primarily it instantiates the todo server client.
func providerConfigure(d *schema.ResourceData, terraformVersion string) (interface{}, error) {
	hostport := d.Get("host").(string) + ":" + d.Get("port").(string)
	apipath := d.Get("apipath").(string)
	schema := d.Get("schema").(string)
	transport := httptransport.New(hostport, apipath, []string{schema})
	transport.Consumers["application/spkane.todo-list.v1+json"] = runtime.JSONConsumer()
	transport.Producers["application/spkane.todo-list.v1+json"] = runtime.JSONProducer()
	// Insantiate the client that we will use to talk to the Todo server
	client := client.New(transport, strfmt.Default)

	params := todos.NewFindTodosParams()
	var limit int32 = 1
	params.SetLimit(&limit)
	// Let's make sure we can talk to the server now
	_, err := client.Todos.FindTodos(params)
	if err != nil {
		return nil, err
	}

	return client, nil

}
