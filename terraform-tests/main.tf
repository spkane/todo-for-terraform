provider "todo" {
  host = "127.0.0.1"
  port = "8080"
  apipath = "/"
  schema = "http"
}

data "todo" "foreign" {
  id = 1
}

resource "todo" "test1" {
  count = 5
  description = "${count.index}-1 test todo"
  completed = false
}

resource "todo" "test2" {
  count = 5
  description = "${count.index}-2 test todo (linked to ${data.todo.foreign.id})"
  completed = false
}
