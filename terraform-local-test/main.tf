terraform {
  required_version = "> 1.6.0"
}

data "external" "public_ip" {
  program = ["./bin/local-ip.sh"]
}

resource "local_file" "external_ip_file" {
  content = "IP: ${data.external.public_ip.result.public_ip}"
  filename = "/tmp/external_ip_file.txt"
}

