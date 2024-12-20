output "todo_solo_ids" {
  value = todo_todo.solo.id
}

output "todo_1_ids" {
  value = todo_todo.test1.*.id
}

output "todo_2_ids" {
  value = todo_todo.test2.*.id
}
