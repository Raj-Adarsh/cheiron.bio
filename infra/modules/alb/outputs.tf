output "service_a_tg_arn" {
  value       = aws_lb_target_group.service_a_tg.arn
  description = "ARN of the service A target group."
}

output "service_b_tg_arn" {
  value       = aws_lb_target_group.service_b_tg.arn
  description = "ARN of the service B target group."
}
