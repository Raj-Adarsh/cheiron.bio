# ECR Module: Creates two repositories for service_a and service_b

resource "aws_ecr_repository" "service_a" {
  name                 = var.service_a_repo_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "service_a_ecr"
  }
}

resource "aws_ecr_repository" "service_b" {
  name                 = var.service_b_repo_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "service_b_ecr"
  }
}
