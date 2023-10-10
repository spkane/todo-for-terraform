terraform {
  required_providers {
    todo = {
      source  = "spkane/todo"
      version = "2.0.5"
    }
  }
}

provider "todo" {
  host = "127.0.0.1"
  port = "8080"
  apipath = "/"
  schema = "http"
}

data "todo_todo" "foreign" {
  id = 1
}

resource "todo_todo" "test1" {
  count = 5
  description = "${count.index}-1 ${var.purpose} todo"
  completed = false
}

resource "todo_todo" "test2" {
  count = 5
  description = "${count.index}-2 ${var.purpose} todo (linked to ${data.todo_todo.foreign.description})"
  completed = false
}
