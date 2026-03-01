variable "http_port" {
  description = "Port for HTTP listeners"
  type        = number
}
variable "service_a_port" {
  description = "Port for service A target group"
  type        = number
}

variable "service_b_port" {
  description = "Port for service B target group"
  type        = number
}

variable "http_protocol" {
  description = "Protocol for HTTP listeners and health checks"
  type        = string
  default     = "HTTP"
}

variable "https_protocol" {
  description = "Protocol for HTTPS listeners"
  type        = string
  default     = "HTTPS"
}

# variable "cert" {
#   description = "ARN of the SSL certificate"
#   type        = string
# }

variable "https_port" {
  description = "Port for HTTPS listeners"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target groups"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "lb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}
