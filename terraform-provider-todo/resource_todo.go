package main

import (
	"log"
	"strconv"

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
		Importer: &schema.ResourceImporter{
			State: schema.ImportStatePassthrough,
		},
		//Exists: resourceTodoExists,
		// Exists can be used to take some load off of Read,
		// but we do not need it here as it won't save any time.

		Schema: map[string]*schema.Schema{
			"description": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
			"completed": &schema.Schema{
				Type:     schema.TypeBool,
				Required: true,
			},
		},
	}
}

func resourceTodoCreate(d *schema.ResourceData, m interface{}) error {

	c := m.(*client.TodoList)

	description := d.Get("description").(string)
	status := d.Get("completed").(bool)
	completed := &status

	// ID is read-only, and is not set directly by terraform
	var todo = models.Item{Completed: completed, Description: &description, ID: 0}
	params := todos.NewAddOneParams()
	params.SetBody(&todo)
	result, err := c.Todos.AddOne(params)
	if err != nil {
		log.Printf("[DEBUG] %s", err)
	}
	d.SetId(strconv.FormatInt(result.GetPayload().ID, 10))
	return resourceTodoRead(d, m)
}

func resourceTodoRead(d *schema.ResourceData, m interface{}) error {
	c := m.(*client.TodoList)

	id, err := strconv.Atoi(d.Id())
	if err != nil {
		log.Printf("[DEBUG] %s", err)
		return err
	}

	params := todos.NewFindTodoParams()
	params.SetID(int64(id))
	result, err := c.Todos.FindTodo(params)

	// If the resource does not exist, inform Terraform. We want to immediately
	// return here to prevent further processing.
	if err != nil {
		d.SetId("")
		return nil
	}

	item := result.GetPayload()
	description := item[0].Description
	completed := item[0].Completed

	// Tell terraform what we got back from the upstream API
	err = d.Set("description", &description)
	if err != nil {
		return err
	}
	err = d.Set("completed", &completed)
	if err != nil {
		return err
	}
	return nil
}

func resourceTodoUpdate(d *schema.ResourceData, m interface{}) error {
	// Enable partial state mode
	// We don't really need this since we can update
	// everything with a single call.
	//d.Partial(true)

	c := m.(*client.TodoList)

	// start here - Maybe read and update are broken? (why not delete -- where are IDs)?
	if d.HasChange("description") || d.HasChange("completed") {
		// Try updating the todo
		description := d.Get("description").(string)
		completed := d.Get("completed").(bool)

		id, err := strconv.Atoi(d.Id())
		if err != nil {
			log.Printf("[DEBUG] %s", err)
			return err
		}

		var todo = models.Item{Completed: &completed, Description: &description}
		params := todos.NewUpdateOneParams()
		params.SetBody(&todo)
		params.SetID(int64(id))
		_, err = c.Todos.UpdateOne(params)
		if err != nil {
			log.Printf("[DEBUG] %s", err)
			return err
		}

		// If we had to handle description and completion with different
		// API calls and we were to return only after updating description,
		// and before disabling partial mode below,
		// then only the "description" field would be saved.

		//d.SetPartial("description")
	}

	// We succeeded, disable partial mode.
	// This causes Terraform to save all fields again.
	//d.Partial(false)

	return resourceTodoRead(d, m)
}

func resourceTodoDelete(d *schema.ResourceData, m interface{}) error {
	c := m.(*client.TodoList)

	id, err := strconv.Atoi(d.Id())
	if err != nil {
		log.Printf("[DEBUG] %s", err)
		return err
	}

	params := todos.NewDestroyOneParams()
	params.SetID(int64(id))
	_, err = c.Todos.DestroyOne(params)
	if err != nil {
		log.Printf("[DEBUG] %s", err)
	}

	// As long as there are no hard errors, we can tell terraform
	// to delete the resource as it might have been deleted out of band.
	d.SetId("")
	return nil
}
