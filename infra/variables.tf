# variable "project" {
#   description = "The name of the AWS project"
#   type        = string
# }

variable "aws_region" {
  description = "The name of the AWS Region"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "EC2 Instance Profile Name"
  type        = string
}

variable "iam_role_policy_name" {
  description = "EC2 Role Policy Name"
  type        = string
}

variable "iam_role_name" {
  description = "EC2 Role Name"
  type        = string
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
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

# Added for network, ec2, and alb modules
variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "az_a" {
  description = "Availability Zone for the first subnet"
  type        = string
}

variable "az_b" {
  description = "Availability Zone for the second subnet"
  type        = string
}

variable "protocol" {
  description = "Protocol to use for security group rules"
  type        = string
  default     = "tcp"
}

variable "ssh_port" {
  description = "Port number for SSH access"
  type        = number
  default     = 22
}

variable "app_port" {
  description = "Port number for application access (e.g., 8080)"
  type        = number
  default     = 8080
}

variable "http_port" {
  description = "HTTP port for load balancer"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port for load balancer"
  type        = number
  default     = 443
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "aws_key" {
  description = "AWS key pair name for EC2 instances"
  type        = string
}

variable "volume_size" {
  description = "Root volume size for EC2 instances"
  type        = number
}

variable "volume_type" {
  description = "Root volume type for EC2 instances"
  type        = string
}

variable "scale_up_threshold" {
  description = "Scale up threshold for EC2 autoscaling"
  type        = number
}
