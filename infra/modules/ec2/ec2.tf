# Create the IAM Role
resource "aws_iam_role" "ec2_role" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Create an IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.iam_instance_profile_name

}

# Scale Up Policy: Increase capacity by 1 when triggered

# Scale Up Policy for service_a
resource "aws_autoscaling_policy" "service_a_scale_up_policy" {
  name                   = "service_a_scale_up_policy"
  autoscaling_group_name = aws_autoscaling_group.service_a_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}

# Scale Down Policy for service_a
resource "aws_autoscaling_policy" "service_a_scale_down_policy" {
  name                   = "service_a_scale_down_policy"
  autoscaling_group_name = aws_autoscaling_group.service_a_asg.name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}

# Scale Up Policy for service_b
resource "aws_autoscaling_policy" "service_b_scale_up_policy" {
  name                   = "service_b_scale_up_policy"
  autoscaling_group_name = aws_autoscaling_group.service_b_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}

# Scale Down Policy for service_b
resource "aws_autoscaling_policy" "service_b_scale_down_policy" {
  name                   = "service_b_scale_down_policy"
  autoscaling_group_name = aws_autoscaling_group.service_b_asg.name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Launch Template for service_a
resource "aws_launch_template" "service_a_lt" {
  name_prefix   = "devops-asg-service-a-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.aws_key

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.app_sg_id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
      encrypted             = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    systemctl start docker
    systemctl enable docker
    curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose || true
    REGION="${var.aws_region}"
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin 905418442014.dkr.ecr.$REGION.amazonaws.com
    curl -o /home/ubuntu/docker-compose.yml https://raw.githubusercontent.com/your-username/your-repo/branch/docker-compose.yml
    export APP_IMAGE="905418442014.dkr.ecr.${var.aws_region}.amazonaws.com/service_a"
    export APP_TAG="latest"
    export APP_PORT=${var.service_a_port}
    export HEALTH_PATH="/healthz"
    export CMD="python /app/service_a.py"
    cd /home/ubuntu
    docker-compose up -d
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Web-Application-ServiceA"
  }
}

# Launch Template for service_b
resource "aws_launch_template" "service_b_lt" {
  name_prefix   = "devops-asg-service-b-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.aws_key

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.app_sg_id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
      encrypted             = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    systemctl start docker
    systemctl enable docker
    curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose || true
    REGION="${var.aws_region}"
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin 905418442014.dkr.ecr.$REGION.amazonaws.com
    curl -o /home/ubuntu/docker-compose.yml https://raw.githubusercontent.com/your-username/your-repo/branch/docker-compose.yml
    export APP_IMAGE="905418442014.dkr.ecr.${var.aws_region}.amazonaws.com/service_b"
    export APP_TAG="latest"
    export APP_PORT=${var.service_b_port}
    export HEALTH_PATH="/healthz"
    export CMD="python /app/service_b.py"
    cd /home/ubuntu
    docker-compose up -d
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Web-Application-ServiceB"
  }
}

# ASG for service_a
resource "aws_autoscaling_group" "service_a_asg" {
  name                = "webapp-asg-service-a"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  default_cooldown    = 60
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.service_a_tg_arn]

  launch_template {
    id      = aws_launch_template.service_a_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Web-Application-ServiceA"
    propagate_at_launch = true
  }
}

# ASG for service_b
resource "aws_autoscaling_group" "service_b_asg" {
  name                = "webapp-asg-service-b"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  default_cooldown    = 60
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.service_b_tg_arn]

  launch_template {
    id      = aws_launch_template.service_b_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Web-Application-ServiceB"
    propagate_at_launch = true
  }
}

# CloudWatch Alarm to trigger Scale Up for service_a when average CPU > threshold
resource "aws_cloudwatch_metric_alarm" "service_a_cpu_high_alarm" {
  alarm_name          = "service_a_cpu_high_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scale_up_threshold
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.service_a_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.service_a_scale_up_policy.arn]
}

# CloudWatch Alarm to trigger Scale Up for service_b when average CPU > threshold
resource "aws_cloudwatch_metric_alarm" "service_b_cpu_high_alarm" {
  alarm_name          = "service_b_cpu_high_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scale_up_threshold
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.service_b_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.service_b_scale_up_policy.arn]
}
