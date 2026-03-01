# Auto-generated values for all variables in the project
# Fill in real values as needed

# project = "my-aws-project"
aws_region                = "us-west-2"
iam_instance_profile_name = "my-instance-profile"
iam_role_policy_name      = "my-role-policy"
iam_role_name             = "my-role"
aws_profile               = "infra"
service_a_port            = 8080
service_b_port            = 8080
http_protocol             = "HTTP"
https_protocol            = "HTTPS"
# cert = "arn:aws:acm:us-west-2:123456789012:certificate/abc123"



# Module: network
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr_a = "10.0.10.0/24"
public_subnet_cidr_b = "10.0.20.0/24"
az_a                 = "us-west-2a"
az_b                 = "us-west-2b"
protocol             = "tcp"
ssh_port             = 22
app_port             = 8080
http_port            = 80
https_port           = 443

# Module: ec2
ami                = "ami-0233d2606cf2ca76c"
instance_type      = "t2.micro"
aws_key            = "devops_ec2_keypair"
volume_size        = 20
volume_type        = "gp2"
scale_up_threshold = 40
