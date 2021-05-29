terraform {
  required_providers {
    todo = {
      source  = "terraform.spkane.org/spkane/todo"
      version = "1.1.0"
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

