package main

import (
	"log"
	"strconv"

	"github.com/go-openapi/runtime"
	httptransport "github.com/go-openapi/runtime/client"
	strfmt "github.com/go-openapi/strfmt"
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	"github.com/spkane/todo-api-example/client"
	"github.com/spkane/todo-api-example/client/todos"
	"github.com/spkane/todo-api-example/models"
)

func resourceTodo() *schema.Resource {
	return &schema.Resource{
		Create: resourceTodoCreate,
		Read:   resourceTodoRead,
		Update: resourceTodoUpdate,
		Delete: resourceTodoDelete,

		Schema: map[string]*schema.Schema{
			"description": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
		},
	}
}

func resourceTodoCreate(d *schema.ResourceData, m interface{}) error {
	transport := httptransport.New("127.0.0.1:8080", "/", []string{"http"})
	transport.Consumers["application/spkane.todo-list.v1+json"] = runtime.JSONConsumer()
	transport.Producers["application/spkane.todo-list.v1+json"] = runtime.JSONProducer()
	c := client.New(transport, strfmt.Default)
	description := d.Get("description").(string)
	var todo = models.Item{Completed: false, Description: &description, ID: 0}

	params := todos.NewAddOneParams()
	params.SetBody(&todo)
	result, err := c.Todos.AddOne(params)
	if err != nil {
		log.Println(err)
	}
	d.SetId(strconv.FormatInt(result.GetPayload().ID, 10))
	return resourceTodoRead(d, m)
}

func resourceTodoRead(d *schema.ResourceData, m interface{}) error {
	return nil
}

func resourceTodoUpdate(d *schema.ResourceData, m interface{}) error {
	return resourceTodoRead(d, m)
}

func resourceTodoDelete(d *schema.ResourceData, m interface{}) error {
	return nil
}
