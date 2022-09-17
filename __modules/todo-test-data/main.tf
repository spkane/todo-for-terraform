terraform {
  required_providers {
    todo = {
      source  = "spkane/todo"
      version = "1.2.3"
    }
  }
}

resource "todo" "first_series" {
  count = var.number
  description = "${var.team_name}-${count.index} ${var.purpose} todo"
  completed = false
}

resource "todo" "second_series" {
  count = var.number
  description = "[${count.index + var.number}] ${var.descriptions[count.index]}"
  completed = true
}

