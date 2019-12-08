package todo

import (
	"log"
	"strconv"

	"github.com/hashicorp/terraform/helper/schema"
	"github.com/spkane/todo-for-terraform/client"
	"github.com/spkane/todo-for-terraform/client/todos"
)

// dataSourceTodo returns the dataSourceTodo resource schema
func dataSourceTodo() *schema.Resource {
	return &schema.Resource{
		Read: dataSourceTodoRead,

		Schema: map[string]*schema.Schema{
			"id": &schema.Schema{
				Type:     schema.TypeInt,
				Required: true,
			},
			"description": &schema.Schema{
				Type:     schema.TypeString,
				Computed: true,
			},
			"completed": &schema.Schema{
				Type:     schema.TypeBool,
				Computed: true,
			},
		},
	}
}

// dataSourceTodoRead reads a single todo and returns it as a datasource.
func dataSourceTodoRead(d *schema.ResourceData, m interface{}) error {
	c := m.(*client.TodoList)

	id := int64(d.Get("id").(int))

	params := todos.NewFindTodoParams()
	params.SetID(int64(id))
	result, err := c.Todos.FindTodo(params)
	if err != nil {
		return err
	}

	item := result.GetPayload()

	description := item[0].Description
	completed := item[0].Completed

	// Tell terraform what we got back from the upstream API
	err = d.Set("description", *description)
	log.Printf("%v", d.Get("description"))
	if err != nil {
		return err
	}
	err = d.Set("completed", *completed)
	log.Printf("%v", d.Get("description"))
	if err != nil {
		return err
	}

	d.SetId(strconv.Itoa(int(id)))

	return nil
}
