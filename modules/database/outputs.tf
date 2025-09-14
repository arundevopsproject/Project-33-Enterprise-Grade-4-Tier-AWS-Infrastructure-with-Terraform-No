output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.mysqldb.id
}

output "database_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.mysqldb.identifier
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.mysqldb.arn
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.mysqldb.endpoint
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.mysqldb.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.mysqldb.db_name
}

output "db_username" {
  description = "Database username"
  value       = aws_db_instance.mysqldb.username
  sensitive   = true
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.main.name
}

output "db_parameter_group_name" {
  description = "DB parameter group name"
  value       = aws_db_parameter_group.main.name
}