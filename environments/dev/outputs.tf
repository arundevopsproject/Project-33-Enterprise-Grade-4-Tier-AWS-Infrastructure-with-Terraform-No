// outputs.tf for dev environment
output "load_balancer_dns" {
  description = "Load balancer DNS name - use this to access your application"
  value       = module.compute.load_balancer_dns
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "database_endpoint" {
  description = "Database endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "database_port" {
  description = "Database port"
  value       = module.database.db_port
  sensitive   = true
}

# Monitoring outputs
output "dashboard_url" {
  description = "CloudWatch Dashboard URL"
  value       = module.monitoring.dashboard_url
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for alerts"
  value       = module.monitoring.sns_topic_arn
}

output "monitoring_alarms" {
  description = "List of monitoring alarm names"
  value       = module.monitoring.alarm_names
}
