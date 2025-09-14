// main.tf for prod environment

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"
  
  environment             = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
}

module "compute" {
  source = "../../modules/compute"
  
  environment = var.environment
  
  # Pass networking outputs to compute module
  vpc_id                     = module.networking.vpc_id
  public_subnet_ids          = module.networking.public_subnet_ids
  private_subnet_ids         = module.networking.private_subnet_ids
  web_tier_security_group_id = module.networking.web_tier_security_group_id
  app_tier_security_group_id = module.networking.app_tier_security_group_id
  
  # Production-specific compute settings
  instance_type    = var.instance_type
  key_name        = var.key_name
  min_size        = var.min_size
  max_size        = var.max_size
  desired_capacity = var.desired_capacity
}

# Add to existing modules
module "database" {
  source = "../../modules/database"
  
  environment = var.environment
  
  # Pass networking outputs
  vpc_id                    = module.networking.vpc_id
  private_subnet_ids        = module.networking.private_subnet_ids
  db_tier_security_group_id = module.networking.db_tier_security_group_id
  
  # Production database configuration
  db_password              = var.db_password
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  backup_retention_period = var.db_backup_retention_period
  multi_az               = var.db_multi_az
  skip_final_snapshot    = var.db_skip_final_snapshot
}

# Add monitoring module
module "monitoring" {
  source = "../../modules/monitoring"
  
  environment = var.environment
  
  # Pass required resource identifiers for monitoring
  autoscaling_group_name = module.compute.autoscaling_group_name
  load_balancer_arn      = module.compute.load_balancer_arn
  target_group_arn       = module.compute.target_group_arn
  database_identifier    = module.database.database_identifier
  
  # Optional: Add notification email if desired
  notification_email = var.notification_email
  
  # Production thresholds (more strict)
  cpu_high_threshold         = 70
  cpu_low_threshold          = 15
  database_cpu_threshold     = 70
  database_connection_threshold = 80
  unhealthy_host_threshold   = 1
}
