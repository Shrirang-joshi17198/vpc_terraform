output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.alb_arn.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb_dns_name.dns_name
}
