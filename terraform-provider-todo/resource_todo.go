package main

import (
	"fmt"

	httptransport "github.com/go-openapi/runtime/client"
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	"github.com/spkane/todo-api-example/client"
	"github.com/spkane/todo-api-example/client/todo"
	//"github.com/spkane/todo-api-example/models"
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
	c := client.New(transport, nil)
	//var todo = models.Item{false, "this is a todo"}

	params := todo.
	something, _ := c.Todos.NewFindTodosParams()
	fmt.Printf("%v", something)
	description := d.Get("description").(string)
	d.SetId(description)
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
