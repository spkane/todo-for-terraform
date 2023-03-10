resource "aws_security_group" "instances" {
  name = "instances"
  description = "Security group for ec2 instances"
  vpc_id      = data.terraform_remote_state.training_account.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.0.0.0/16"]
    self        = true
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${data.external.public_ip.result.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = { 
    Name = "terraform-training-spkane"
    Trainer = "Sean P. Kane"
  }
}

resource "aws_security_group" "public_lb" {
  name = "public-lb"
  description = "Security group for public load balancers"
  vpc_id      = data.terraform_remote_state.training_account.outputs.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = { 
    Name = "terraform-training-spkane"
    Trainer = "Sean P. Kane"
  }
}
