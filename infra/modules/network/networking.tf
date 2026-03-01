
# Single VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# First public subnet in the VPC and AZ A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_a
  availability_zone       = var.az_a
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-a"
  }
}

# Second public subnet in the VPC and AZ B
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_b
  availability_zone       = var.az_b
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-rt"
  }
}

# Route to Internet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Associate public_subnet_a with public route table
resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

# Associate public_subnet_b with public route table
resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public.id
}

# Create Security Group
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Application-Security-Group"
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Load-Balancer-Security-Group"
  }
}
