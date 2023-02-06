output "first_series_ids" {
  value = todo_todo.first_series.*.id
}

output "second_series_ids" {
  value = todo_todo.second_series.*.id
}