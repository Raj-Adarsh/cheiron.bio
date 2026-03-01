terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "ecr" {
  source              = "./modules/ecr"
  service_a_repo_name = "service-a-repo"
  service_b_repo_name = "service-b-repo"
}

# Network module
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr_a = var.public_subnet_cidr_a
  public_subnet_cidr_b = var.public_subnet_cidr_b
  az_a                 = var.az_a
  az_b                 = var.az_b
  protocol             = var.protocol
  ssh_port             = var.ssh_port
  app_port             = var.app_port
  http_port            = var.http_port
  https_port           = var.https_port
}

# EC2 module
module "ec2" {
  source                    = "./modules/ec2"
  service_a_port            = var.service_a_port
  service_b_port            = var.service_b_port
  iam_role_name             = var.iam_role_name
  iam_instance_profile_name = var.iam_instance_profile_name
  ami                       = var.ami
  instance_type             = var.instance_type
  aws_key                   = var.aws_key
  volume_size               = var.volume_size
  volume_type               = var.volume_type
  aws_region                = var.aws_region
  scale_up_threshold        = var.scale_up_threshold
  app_sg_id                 = module.network.app_sg_id
  public_subnet_ids         = module.network.public_subnet_ids
  service_a_tg_arn          = module.alb.service_a_tg_arn
  service_b_tg_arn          = module.alb.service_b_tg_arn
}

# ALB module
module "alb" {
  source            = "./modules/alb"
  service_a_port    = var.service_a_port
  service_b_port    = var.service_b_port
  http_protocol     = var.http_protocol
  https_protocol    = var.https_protocol
  https_port        = var.https_port
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  lb_sg_id          = module.network.lb_sg_id
  http_port         = var.http_port
}
