package todo

import (
	"fmt"
	"testing"

	"github.com/hashicorp/terraform/helper/resource"
	"github.com/hashicorp/terraform/terraform"
)

func TestAccDataSourceTodo_basic(t *testing.T) {
	resource.ParallelTest(t, resource.TestCase{
		PreCheck:  func() { testAccPreCheck(t) },
		Providers: testAccProviders,
		Steps: []resource.TestStep{
			{
				Config: testAccDataSourceTodoConfig_basic(1),
				Check: resource.ComposeTestCheckFunc(
					testAccCheckTodoDataSourceID("data.todo.acctest"),
				),
			},
		},
	})
}

func testAccDataSourceTodoConfig_basic(id int64) string {
	return fmt.Sprintf(`data "todo" "acctest" {
  id = %d
}
`, id)
}

func testAccCheckTodoDataSourceID(n string) resource.TestCheckFunc {
	return func(s *terraform.State) error {
		rs, ok := s.RootModule().Resources[n]
		if !ok {
			return fmt.Errorf("Can't find todo data source: %s", n)
		}

		if rs.Primary.ID == "" {
			return fmt.Errorf("todo data source ID not set")
		}
		return nil
	}
}
