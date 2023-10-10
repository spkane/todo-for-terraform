terraform {
  required_providers {
    todo = {
      source  = "spkane/todo"
      version = "2.0.5"
    }
  }
}

resource "todo_todo" "first_series" {
  count = var.number
  description = "${var.team_name}-${count.index} ${var.purpose} todo"
  completed = false
}

resource "todo_todo" "second_series" {
  count = var.number
  description = "[${count.index + var.number}] ${var.descriptions[count.index]}"
  completed = true
}

