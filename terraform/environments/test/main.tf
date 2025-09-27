module "vpc" {
  source               = "../../modules/vpc"
  env                  = var.env
  vpc_cidr_block       = var.vpc_cidr_block
  vpc-name             = var.vpc-name
  public_subnet_count  = var.public_subnet_count
  private-subnet-count = var.private-subnet-count
  public_sub_name      = var.public_sub_name
  private_sub_name     = var.private_sub_name
  igw-name             = var.igw-name
  eip-name             = var.eip-name
  ngw-name             = var.ngw-name
  public-rt-name       = var.public-rt-name
  private-rt-name      = var.private-rt-name
}

module "security_groups" {
  source = "../../modules/security_groups"

  alb_sg_name                 = var.alb_sg_name
  alb_sg_description          = var.alb_sg_description
  vpc_id                      = module.vpc.vpc_id
  alb_ingress_http_from_port  = var.alb_ingress_http_from_port
  alb_ingress_http_to_port    = var.alb_ingress_http_to_port
  alb_ingress_cidr_blocks     = var.alb_ingress_cidr_blocks
  alb_ingress_https_from_port = var.alb_ingress_https_from_port
  alb_ingress_https_to_port   = var.alb_ingress_https_to_port
  ecs_egress_cidr_blocks      = var.ecs_egress_cidr_blocks
  ecs_sg_name                 = var.ecs_sg_name
  ecs_sg_description          = var.ecs_sg_description
  ecs_ingress_from_port       = var.ecs_ingress_from_port
  ecs_ingress_to_port         = var.ecs_ingress_to_port
  ecs_egress_from_port        = var.ecs_egress_from_port
  ecs_egress_to_port          = var.ecs_egress_to_port
  ingress_protocol            = var.ingress_protocol
  egress_protocol             = var.egress_protocol
}

module "iam" {
  source = "../../modules/iam"
  env    = var.env
}

module "route53" {
  source         = "../../modules/route53"
  hosted_zone_id = var.hosted_zone_id
  record_name    = var.record_name
  alb_dns_name   = module.frontend_alb.alb_dns_name
  alb_zone_id    = module.frontend_alb.alb_zone_id
  record_type    = var.record_type
}

module "acm" {
  source         = "../../modules/acm"
  domain_name    = var.record_name
  hosted_zone_id = var.hosted_zone_id
}

module "frontend_alb" {
  source                  = "../../modules/alb"
  alb_name                = var.alb_name
  env                     = var.env
  subnet_ids              = module.vpc.public_subnet_ids
  security_group_id       = module.security_groups.alb_sg_id
  vpc_id                  = module.vpc.vpc_id
  target_port             = 80
  listener_port           = 80
  health_check_path       = "/"
  alb_internal            = var.alb_internal
  target_group_name       = var.target_group_name
  alb_deletion_protection = var.alb_deletion_protection
  certificate_arn         = module.acm.certificate_arn
  https_listener_port     = var.https_listener_port
  https_listener_protocol = var.https_listener_protocol
  ssl_policy              = var.ssl_policy
}

module "frontend_service" {
  source                = "../../modules/ecs_fargate"
  cluster_name          = var.cluster_name
  service_name          = var.service_name
  env                   = var.env
  container_port        = 80
  subnet_ids            = module.vpc.private_subnet_ids
  security_group_ids    = [module.security_groups.ecs_sg_id]
  execution_role_arn    = module.iam.ecs_execution_role_arn
  task_family           = var.task_family
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  image_url             = var.image_url
  cluster_insight_name  = var.cluster_insight_name
  cluster_insight_value = var.cluster_insight_value
  desired_count         = var.desired_count
  container_name        = var.container_name
  target_group_arn      = module.frontend_alb.target_group_arn
}