resource "aws_lb" "app_lb" {
  name               = "${var.project_name}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids 
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-app-lb"
  })
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-app-tg"
  })
}

resource "aws_lb_listener" "winter-listener-http" {
  load_balancer_arn = aws_lb.delta-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "winter-listener-https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}
