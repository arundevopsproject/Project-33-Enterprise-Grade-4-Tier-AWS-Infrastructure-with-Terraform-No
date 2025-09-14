// variables.tf for compute module
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from networking module"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs from networking module"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs from networking module"
  type        = list(string)
}

variable "web_tier_security_group_id" {
  description = "Security group ID for web tier from networking module"
  type        = string
}

variable "app_tier_security_group_id" {
  description = "Security group ID for app tier from networking module"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = ""
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}