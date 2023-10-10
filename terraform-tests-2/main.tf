terraform {
  required_providers {
    todo = {
      source  = "spkane/todo"
      version = "2.0.5"
    }
  }
}

provider "todo" {
  host = "todo-api.techlabs.sh"
  port = "8080"
  apipath = "/"
  schema = "http"
}

resource "todo_todo" "step_2" {
  count = 5
  description = "${count.index}: ${var.purpose} todo"
  completed = false
}
