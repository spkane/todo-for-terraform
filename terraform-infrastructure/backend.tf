resource "aws_instance" "todo" {
  count         = "1"
  ami           = "ami-5c66ea23"
  instance_type = "m5.large"
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = data.terraform_remote_state.training_account.outputs.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.instances.id]
  associate_public_ip_address = true
  connection {
    host = self.public_ip
    user = "ubuntu"
    private_key = file(var.ssh_private_key_path)
  }
  provisioner "file" {
    source = "./files/startup_options.conf"
    destination = "/tmp/startup_options.conf"
  }
  provisioner "file" {
    source = "./files/daemon.json"
    destination = "/tmp/daemon.json"
  }
  provisioner "file" {
    source = "./files/todo-list.service"
    destination = "/tmp/todo-list.service"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce",
      "sudo usermod -aG docker ubuntu",
      "wget https://storage.googleapis.com/gvisor/releases/nightly/latest/runsc",
      "chmod +x runsc",
      "sudo mv runsc /usr/local/bin",
      "sudo cp /tmp/daemon.json /etc/docker/daemon.json",
      "sudo cp /tmp/todo-list.service /etc/systemd/system/todo-list.service",
      "sudo mkdir -p /etc/systemd/system/docker.service.d/",
      "sudo cp /tmp/startup_options.conf /etc/systemd/system/docker.service.d/startup_options.conf",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable todo-list",
      "sudo service docker restart",
      "sudo systemctl start todo-list",
    ]
  }
  tags = {
    Name = "terraform-${count.index}-spkane"
    Trainer = "Sean P. Kane"
  }
}

