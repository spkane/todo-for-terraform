provider "todo" {
  host = "127.0.0.1"
  port = "8080"
  apipath = "/"
  schema = "http"
}

resource "todo" "test1" {
  count = 5
  description = "${count.index}-1 test todo"
  completed = false
}

resource "todo" "test2" {
  count = 6
  description = "${count.index}-2 test todo"
  completed = false
}
