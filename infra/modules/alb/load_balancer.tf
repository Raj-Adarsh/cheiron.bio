# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = var.public_subnet_ids
  tags = {
    Name = "Application-Load-Balancer"
  }
}


# Target Group for service_a
resource "aws_lb_target_group" "service_a_tg" {
  name     = "service-a-tg"
  port     = var.service_a_port
  protocol = var.http_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = var.http_protocol
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Service-A-Target-Group"
  }
}

# Target Group for service_b
resource "aws_lb_target_group" "service_b_tg" {
  name     = "service-b-tg"
  port     = var.service_b_port
  protocol = var.http_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = var.http_protocol
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Service-B-Target-Group"
  }
}


# HTTP Listener for the ALB to forward traffic to the correct target group based on path
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# Listener rule for service_a
resource "aws_lb_listener_rule" "service_a_rule" {
  listener_arn = aws_lb_listener.app_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_a_tg.arn
  }

  condition {
    path_pattern {
      values = ["/service_a*", "/service_a/*", "/health", "/api/ping"]
    }
  }
}

# Listener rule for service_b
resource "aws_lb_listener_rule" "service_b_rule" {
  listener_arn = aws_lb_listener.app_listener.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_b_tg.arn
  }

  condition {
    path_pattern {
      values = ["/service_b*", "/service_b/*", "/health", "/api/ping"]
    }
  }
}
