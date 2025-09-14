// main.tf for database module

# Get the default AWS RDS KMS key
data "aws_kms_alias" "rds" {
  name = "alias/aws/rds"
}



# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_parameter_group" "main" {
  family = "mysql8.4"
  name   = "${var.environment}-db-params"

  parameter {
    name  = "innodb_buffer_pool_size"
    value = "{DBInstanceClassMemory*3/4}"
  }

  parameter {
    name  = "max_connections"
    value = "100"
  }

  tags = {
    Name        = "${var.environment}-db-params"
    Environment = var.environment
  }
}


resource "aws_db_instance" "mysqldb" {
  identifier     = "${var.environment}-mysql-db"

  allocated_storage           = var.allocated_storage
  db_subnet_group_name        = aws_db_subnet_group.main.name
  engine                      = "mysql"
  engine_version              = "8.4.6"  # Use specific version that's available
  instance_class              = "db.t3.micro"
  storage_encrypted           = true
  password                    = var.db_password
  username                    = var.db_username
  max_allocated_storage       = var.max_allocated_storage
  storage_type                = "gp3"
  db_name                     = var.db_name
  vpc_security_group_ids      = [var.db_tier_security_group_id]
  publicly_accessible         = false
  parameter_group_name        = aws_db_parameter_group.main.name
  kms_key_id                  = data.aws_kms_alias.rds.arn  # Use AWS default RDS key
  #performance_insights_enabled = true
  #performance_insights_retention_period = 7  

 # Backup & Maintenance
  backup_retention_period   = var.backup_retention_period
  backup_window            = var.backup_window
  maintenance_window       = var.maintenance_window
  auto_minor_version_upgrade = true

   # Multi-AZ
   multi_az = var.multi_az

# Deletion
 skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.environment == "prod" ? true : false


  # Monitoring
#  monitoring_interval = 60
#  enabled_cloudwatch_logs_exports = ["error", "general", "alert"]

  tags = {
    Name        = "${var.environment}-mysql-db"
    Environment = var.environment
  }

  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
}