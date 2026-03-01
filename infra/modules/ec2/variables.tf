variable "service_a_tg_arn" {
  description = "ARN of the service A target group"
  type        = string
}

variable "service_b_tg_arn" {
  description = "ARN of the service B target group"
  type        = string
}
variable "public_subnet_ids" {
  description = "Public subnet IDs for the ASG"
  type        = list(string)
}
variable "service_a_port" {
  description = "Port for service A"
  type        = string
}

variable "service_b_port" {
  description = "Port for service B"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "aws_key" {
  description = "AWS key pair name"
  type        = string
}

variable "volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
}

variable "volume_type" {
  description = "Type of the EBS volume"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}


variable "scale_up_threshold" {
  description = "CPU utilization percentage to trigger scale up"
  type        = number
  default     = 4
}

variable "app_sg_id" {
  description = "ID of the application security group to attach to EC2 instances"
  type        = string
}
