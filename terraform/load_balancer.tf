resource "aws_lb" "main" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = [aws_subnet.main.id, aws_subnet.main_2.id]

  enable_deletion_protection = false

  tags = {
    Name    = "${var.project_name}-lb"
    Project = var.project_name
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = {
    Name    = "${var.project_name}-lb-listener-tg-1"
    Project = var.project_name
  }
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value = aws_lb.main.dns_name
}

resource "aws_lb_listener" "main_2" {
  load_balancer_arn = aws_lb.main.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_2.arn
  }

  tags = {
    Name    = "${var.project_name}-lb-listener-tg-2"
    Project = var.project_name
  }
}


resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-tg"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/ping"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name    = "${var.project_name}-tg"
    Project = var.project_name
  }
}

resource "aws_lb_target_group" "main_2" {
  name        = "${var.project_name}-tg-2"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/ping"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name    = "${var.project_name}-tg-2"
    Project = var.project_name
  }
}
