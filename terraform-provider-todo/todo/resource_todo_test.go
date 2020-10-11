package todo

import (
	"fmt"
	"strconv"
	"testing"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/resource"
	"github.com/hashicorp/terraform-plugin-sdk/v2/terraform"
	"github.com/spkane/todo-for-terraform/client"
	"github.com/spkane/todo-for-terraform/client/todos"
	"github.com/spkane/todo-for-terraform/models"
)

func TestAccTodo_basic(t *testing.T) {
	var item models.Item
	description := "acceptance test todo"

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testAccCheckTodoDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccTodoBasic(description, false),
				Check: resource.ComposeTestCheckFunc(
					testAccCheckTodoExists("todo.acctest", &item),
					testAccCheckTodoDescription(&item, description),
					testAccCheckTodoCompleted(&item, false),
				),
			},
			{
				ResourceName:      "todo.acctest",
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

func TestAccTodo_updated(t *testing.T) {
	var item models.Item
	description := "acceptance test todo"

	resource.Test(t, resource.TestCase{
		PreCheck:     func() { testAccPreCheck(t) },
		Providers:    testAccProviders,
		CheckDestroy: testAccCheckTodoDestroy,
		Steps: []resource.TestStep{
			{
				Config: testAccTodoBasic(description, false),
				Check: resource.ComposeTestCheckFunc(
					testAccCheckTodoExists("todo.acctest", &item),
					testAccCheckTodoDescription(&item, description),
					testAccCheckTodoCompleted(&item, false),
				),
			},
			{
				Config: testAccTodoUpdated(description, true),
				Check: resource.ComposeTestCheckFunc(
					testAccCheckTodoExists("todo.acctest", &item),
					testAccCheckTodoDescription(&item, description+" (updated)"),
					testAccCheckTodoCompleted(&item, true),
				),
			},
			{
				ResourceName:      "todo.acctest",
				ImportState:       true,
				ImportStateVerify: true,
			},
		},
	})
}

func testAccTodoBasic(description string, completed bool) string {
	return fmt.Sprintf(`resource "todo" "acctest" {
  description = "%s"
  completed = %t
}
`, description, completed)
}

func testAccTodoUpdated(description string, completed bool) string {
	return fmt.Sprintf(`resource "todo" "acctest" {
  description = "%s (updated)"
  completed = %t
}
`, description, completed)
}

func testAccCheckTodoExists(n string, item *models.Item) resource.TestCheckFunc {
	return func(s *terraform.State) error {
		rs, ok := s.RootModule().Resources[n]

		if !ok {
			return fmt.Errorf("not found: %s", n)
		}

		if rs.Primary.ID == "" {
			return fmt.Errorf("no ID is set")
		}

		c := testAccProvider.Meta().(*client.TodoList)

		id, err := strconv.Atoi(rs.Primary.ID)
		if err != nil {
			return fmt.Errorf("[ERROR] %s", err)
		}

		params := todos.NewFindTodoParams()
		params.SetID(int64(id))
		result, err := c.Todos.FindTodo(params)

		// Resource does not exist
		if err != nil {
			return fmt.Errorf("todo was not found: %s", err)
		}

		foundTodo := result.GetPayload()

		p := rs.Primary

		if strconv.Itoa(int(foundTodo[0].ID)) != p.Attributes["id"] {
			return fmt.Errorf("todo IDs do not match, (%s), (%s)", strconv.Itoa(int(foundTodo[0].ID)), p.Attributes["id"])
		}

		*item = *foundTodo[0]

		return nil
	}
}

func testAccCheckTodoDescription(item *models.Item, expected string) resource.TestCheckFunc {
	return func(s *terraform.State) error {
		if *item.Description != expected {
			return fmt.Errorf("item.Description: got: %s want: %s", *item.Description, expected)
		}
		return nil
	}
}

func testAccCheckTodoCompleted(item *models.Item, expected bool) resource.TestCheckFunc {
	return func(s *terraform.State) error {
		if *item.Completed != expected {
			return fmt.Errorf("item.Completed: got: %s want: %t", *item.Description, expected)
		}
		return nil
	}
}

func testAccCheckTodoDestroy(s *terraform.State) error {
	c := testAccProvider.Meta().(*client.TodoList)

	var itemID string

	for _, rs := range s.RootModule().Resources {
		if rs.Type != "todo" {
			continue
		}

		if rs.Type == "todo" {
			itemID = rs.Primary.Attributes["id"]
		}
	}

	id, err := strconv.Atoi(itemID)
	if err != nil {
		return fmt.Errorf("[ERROR] %s", err)
	}

	params := todos.NewFindTodoParams()
	params.SetID(int64(id))
	result, err := c.Todos.FindTodo(params)

	// Resource does not exist
	if err != nil {
		return nil
	}

	foundTodo := result.GetPayload()
	return fmt.Errorf("[ERROR] todo still exists: %#v", foundTodo)

}
