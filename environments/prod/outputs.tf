// outputs.tf for prod environment

# Application Access
output "application_url" {
  description = "🌐 Production Application URL - Access your application here"
  value       = "http://${module.compute.load_balancer_dns}"
}

output "load_balancer_dns" {
  description = "Load balancer DNS name"
  value       = module.compute.load_balancer_dns
}

output "load_balancer_zone_id" {
  description = "Load balancer hosted zone ID for Route 53"
  value       = module.compute.load_balancer_zone_id
}

# Network Information
output "vpc_id" {
  description = "Production VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Production public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Production private subnet IDs"
  value       = module.networking.private_subnet_ids
}

# Database Information
output "database_endpoint" {
  description = "🗄️  Production database endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "database_port" {
  description = "Database port"
  value       = module.database.db_port
}

# Security Groups
output "web_tier_security_group_id" {
  description = "Web tier security group ID"
  value       = module.networking.web_tier_security_group_id
}

output "app_tier_security_group_id" {
  description = "App tier security group ID"
  value       = module.networking.app_tier_security_group_id
}

output "db_tier_security_group_id" {
  description = "Database tier security group ID"
  value       = module.networking.db_tier_security_group_id
}

# Auto Scaling Information
output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = module.compute.autoscaling_group_name
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = module.compute.target_group_arn
}

# Environment Information
output "environment_info" {
  description = "📊 Production Environment Summary"
  value = {
    environment              = var.environment
    region                  = var.aws_region
    vpc_cidr               = var.vpc_cidr
    instance_type          = var.instance_type
    database_class         = var.db_instance_class
    multi_az_enabled       = var.db_multi_az
    backup_retention_days  = var.db_backup_retention_period
    min_instances         = var.min_size
    max_instances         = var.max_size
    current_capacity      = var.desired_capacity
  }
}

# Monitoring Information
output "dashboard_url" {
  description = "📊 CloudWatch Dashboard URL for monitoring"
  value       = module.monitoring.dashboard_url
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for production alerts"
  value       = module.monitoring.sns_topic_arn
}

output "monitoring_alarms" {
  description = "List of monitoring alarm names"
  value       = module.monitoring.alarm_names
}

# Production Deployment Information
output "deployment_info" {
  description = "🚀 Production Deployment Information"
  value = {
    deployment_timestamp = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    infrastructure_ready = "Your production infrastructure is ready!"
    next_steps = [
      "1. Access your application at the URL above",
      "2. Set up SSL/TLS certificate for HTTPS",
      "3. Configure domain name with Route 53",
      "4. Set up monitoring alerts and subscribe to SNS topics",
      "5. Implement backup and disaster recovery",
      "6. Monitor performance via CloudWatch Dashboard"
    ]
  }
}
