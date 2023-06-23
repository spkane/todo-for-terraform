resource "aws_s3_bucket" "lb_logs" {
  bucket = "todo-lb-logs"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

    tags = {
    pupose        = "lb-logs"
    environment   = "todo"
    Trainer       = "Sean P. Kane"
  }
}

resource "aws_s3_bucket_versioning" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lb_logs" {
  depends_on = [aws_s3_bucket_ownership_controls.lb_logs]
  bucket = aws_s3_bucket.lb_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::127311923021:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::todo-lb-logs/*"
    }
  ]
}
EOF
}

resource "aws_lb" "todo" {
  name               = "todo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_lb.id]
  subnets            = data.terraform_remote_state.training_account.outputs.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "todo-lb"
    enabled = true
  }

  tags = {
    Environment = "training"
    Trainer     = "Sean P. Kane"
  }
}

resource "aws_lb_listener" "todo" {
  load_balancer_arn = aws_lb.todo.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.todo.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "todo" {
  name     = "todo-target"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.training_account.outputs.vpc_id

  tags = {
    name    = "todo_target"
    Trainer = "Sean P. Kane"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "8080"
  }
}

resource "aws_lb_target_group_attachment" "todo_instance" {
  target_group_arn = aws_lb_target_group.todo.arn
  target_id        = aws_instance.todo[0].id
  port             = 8080
}

resource "ns1_record" "todo-api" {
  ttl    = 60
  zone   = "spkane.org"
  domain = "todo-api.spkane.org"
  type   = "CNAME"

  meta = {
    note = "todo api training load balancer"
  }

  answers {
    answer = aws_lb.todo.dns_name
  }
}
