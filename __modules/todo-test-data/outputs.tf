output "first_series_ids" {
  value = todo.first_series.*.id
}

output "second_series_ids" {
  value = todo.second_series.*.id
}