# Variables for monitoring module
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "web-platform"
}

# Auto Scaling Group variables
variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group to monitor"
  type        = string
}

# Load Balancer variables
variable "load_balancer_arn" {
  description = "ARN of the Load Balancer to monitor"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the Target Group to monitor"
  type        = string
}

# Database variables
variable "database_identifier" {
  description = "Identifier of the RDS database to monitor"
  type        = string
}

# Notification settings
variable "notification_email" {
  description = "Email address for alarm notifications"
  type        = string
  default     = ""
}

# Alarm thresholds
variable "cpu_high_threshold" {
  description = "CPU utilization threshold for high CPU alarm"
  type        = number
  default     = 80
}

variable "cpu_low_threshold" {
  description = "CPU utilization threshold for low CPU alarm"
  type        = number
  default     = 20
}

variable "unhealthy_host_threshold" {
  description = "Number of unhealthy hosts threshold"
  type        = number
  default     = 1
}

variable "database_cpu_threshold" {
  description = "Database CPU utilization threshold"
  type        = number
  default     = 75
}

variable "database_connection_threshold" {
  description = "Database connection count threshold"
  type        = number
  default     = 50
}