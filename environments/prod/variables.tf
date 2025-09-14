variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"  # Different region for production
}

# Network Configuration - Production uses different CIDR ranges
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"  # Different from dev (10.0.0.0/16)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]  # Production network
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.11.0/24", "10.1.12.0/24"]  # Production network
}

# Compute Configuration - Production specs
variable "instance_type" {
  description = "EC2 instance type for production"
  type        = string
  default     = "t3.large"  # Larger instances for production
}

variable "key_name" {
  description = "EC2 Key Pair name for production"
  type        = string
  default     = "prod-keypair"  # Production key pair
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2  # Higher minimum for production
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 10  # Higher maximum for production
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 4  # Start with more instances in production
}

# Database Configuration - Production specs
variable "db_password" {
  description = "Database password for production"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class for production"
  type        = string
  default     = "db.t3.medium"  # Larger database instance
}

variable "db_allocated_storage" {
  description = "Initial allocated storage for RDS instance (GB)"
  type        = number
  default     = 100  # More storage for production
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for RDS instance (GB)"
  type        = number
  default     = 1000  # Higher autoscaling limit
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 30  # Longer retention for production
}

variable "db_multi_az" {
  description = "Enable multi-AZ deployment for high availability"
  type        = bool
  default     = true  # Enable multi-AZ for production
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when destroying"
  type        = bool
  default     = false  # Create final snapshot in production
}

# Monitoring Configuration
variable "notification_email" {
  description = "Email address for monitoring alerts"
  type        = string
  default     = "admin@yourcompany.com"
}

variable "monitoring_email" {
  description = "Email address for monitoring alerts"
  type        = string
  default     = "admin@yourcompany.com"
}

variable "enable_monitoring_alerts" {
  description = "Enable email notifications for alerts"
  type        = bool
  default     = true  # Enable alerts in production
}

variable "cpu_high_threshold" {
  description = "CPU utilization threshold for scaling up (%)"
  type        = number
  default     = 70  # Lower threshold for production (more responsive)
}

variable "cpu_low_threshold" {
  description = "CPU utilization threshold for scaling down (%)"
  type        = number
  default     = 30  # Higher threshold to avoid aggressive scale-down
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 30  # Longer retention for production
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = true  # Enable detailed monitoring for production
}
