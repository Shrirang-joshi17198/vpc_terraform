resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_listener" "aws_lb_listener" {
  count             = length(var.listeners)
  load_balancer_arn = aws_lb.aws_lb_listener.arn
  port             = var.listeners[count.index].port
  protocol         = var.listeners[count.index].protocol
  default_action {
    type             = "forward"
    target_group_arn = var.listeners[count.index].target_group_arn
  }
}
