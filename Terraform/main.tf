module "vpc" {
    source = "./modules/network"
}


module "ec2" {
    depends_on = [module.vpc]
    source     = "./modules/compute"
    subnet_id  = module.vpc.public_subnet_ids 
    vpc_security_group_ids = [module.vpc.public_sg_id]
    aws_account_id         = var.aws_account_id
    aws_region             = var.aws_region
    ecr_repository         = module.ecr.ecr_repository_url   
    image_tag              = var.image_tag
    ecs_instance_profile_name = module.iam.ecs_instance_profile_name
    # ecs_instance_role_name = module.iam.ecs_instance_role_name

}

module "iam" {
  source = "./modules/iam"
}

module "ecs_cluster" {
  source = "./modules/cluster"
  project_name           = var.project_name
  image_tag              = var.image_tag
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_execution_role_arn
  ecr_repository_url     = module.ecr.ecr_repository_url
  subnet_ids             = module.vpc.public_subnet_ids
  security_group_ids     = [module.vpc.public_sg_id]
  target_group_arn      = module.alb.app_target_group_arn
}

module "ecr" {
  source = "./modules/ecr"
  project_name    = var.project_name
  repository_name = var.repository_name
}

module "alb" {
  source = "./modules/alb"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  security_group_ids = [module.vpc.public_sg_id]
}

module "route53" {
  source = "./modules/route53"
  project_name    = var.project_name
  domain_name = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  app_lb_zone_id = module.alb.app_lb_zone_id
}