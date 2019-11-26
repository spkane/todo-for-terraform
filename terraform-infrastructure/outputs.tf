output "todo_ips" {
  value = join(",", aws_instance.todo.*.public_ip)
}

output "bucket_lb_logs_hostname" {
  value = aws_s3_bucket.lb_logs.bucket_domain_name
}

output "bucket_lb_logs_region_hostname" {
  value = aws_s3_bucket.lb_logs.bucket_regional_domain_name
}

output "lb_todo_hostname" {
  value = aws_lb.todo.dns_name
}

output "todo_api_hostname" {
  value = ns1_record.todo-api.domain
}
