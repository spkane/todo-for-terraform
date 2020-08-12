output "my_external_ip" {
  value = data.external.public_ip.result.public_ip
}

