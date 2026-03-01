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

variable "protocol" {
  description = "Protocol to use for security group rules"
  type        = string
  default     = "tcp"
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
