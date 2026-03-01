output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the main VPC."
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
  description = "The IDs of the public subnets."
}

output "lb_sg_id" {
  value       = aws_security_group.lb_sg.id
  description = "The ID of the load balancer security group."
}

output "app_sg_id" {
  value       = aws_security_group.app_sg.id
  description = "The ID of the application security group."
}
