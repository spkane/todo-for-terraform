output "todo_1_ids" {
  value = "${todo.test1.*.id}"
}

output "todo_2_ids" {
  value = "${todo.test2.*.id}"
}