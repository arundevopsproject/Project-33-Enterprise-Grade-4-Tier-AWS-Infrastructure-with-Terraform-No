// main.tf for dev environment


terraform {
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
  vpc_id                    = module.networking.vpc_id
  public_subnet_ids         = module.networking.public_subnet_ids
  private_subnet_ids        = module.networking.private_subnet_ids
  web_tier_security_group_id = module.networking.web_tier_security_group_id
  app_tier_security_group_id = module.networking.app_tier_security_group_id
  
  
}

# Add to existing modules
module "database" {
  source = "../../modules/database"
  
  environment = var.environment
  
  # Pass networking outputs
  vpc_id                    = module.networking.vpc_id
  private_subnet_ids        = module.networking.private_subnet_ids
  db_tier_security_group_id = module.networking.db_tier_security_group_id
  
  # Database configuration
  db_password = var.db_password  # Add this to environment variables
  multi_az    = false           # Single AZ for dev
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
  
  # Custom thresholds for dev environment
  cpu_high_threshold        = 85
  cpu_low_threshold         = 10
  database_cpu_threshold    = 80
}

