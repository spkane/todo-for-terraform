package main

import (
	"github.com/go-openapi/runtime"
	httptransport "github.com/go-openapi/runtime/client"
	strfmt "github.com/go-openapi/strfmt"
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	"github.com/spkane/todo-api-example/client"
	"github.com/spkane/todo-api-example/client/todos"
)

func Provider() *schema.Provider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"host": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The FQDN or IP address for the todo server",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_HOST", "127.0.0.1"),
			},
			"port": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The port for the todo server",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_PORT", "8080"),
			},
			"schema": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The URL schema for the todo server",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_SCHEMA", "http"),
			},
			"apipath": &schema.Schema{
				Type:        schema.TypeString,
				Description: "The URL path for the todo server API",
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("TODO_APIPATH", "/"),
			},
		},
		DataSourcesMap: map[string]*schema.Resource{
			"todo": dataSourceTodo(),
		},
		ResourcesMap: map[string]*schema.Resource{
			"todo": resourceTodo(),
		},
		ConfigureFunc: configureFunc(),
	}
}

func configureFunc() func(*schema.ResourceData) (interface{}, error) {
	return func(d *schema.ResourceData) (interface{}, error) {
		hostport := d.Get("host").(string) + ":" + d.Get("port").(string)
		apipath := d.Get("apipath").(string)
		schema := d.Get("schema").(string)
		transport := httptransport.New(hostport, apipath, []string{schema})
		transport.Consumers["application/spkane.todo-list.v1+json"] = runtime.JSONConsumer()
		transport.Producers["application/spkane.todo-list.v1+json"] = runtime.JSONProducer()
		client := client.New(transport, strfmt.Default)

		params := todos.NewFindTodosParams()
		var limit int32 = 1
		params.SetLimit(&limit)
		_, err := client.Todos.FindTodos(params)
		if err != nil {
			return nil, err
		}

		return client, nil
	}
}
