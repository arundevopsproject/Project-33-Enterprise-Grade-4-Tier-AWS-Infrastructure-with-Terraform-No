# Data source to get current region
data "aws_region" "current" {}

# SNS Topic for notifications
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-${var.project_name}-alerts"

  tags = {
    Name        = "${var.environment}-${var.project_name}-alerts"
    Environment = var.environment
  }
}

# SNS Topic subscription (email)
resource "aws_sns_topic_subscription" "email_alerts" {
  count     = var.notification_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", substr(var.load_balancer_arn, 50, -1)],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", substr(var.load_balancer_arn, 50, -1)],
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", substr(var.load_balancer_arn, 50, -1)],
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", substr(var.load_balancer_arn, 50, -1)]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "Load Balancer Metrics"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", var.autoscaling_group_name],
            ["AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", var.autoscaling_group_name],
            ["AWS/AutoScaling", "GroupMinSize", "AutoScalingGroupName", var.autoscaling_group_name],
            ["AWS/AutoScaling", "GroupMaxSize", "AutoScalingGroupName", var.autoscaling_group_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "Auto Scaling Group Metrics"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.autoscaling_group_name],
            ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", substr(var.target_group_arn, 73, -1), "LoadBalancer", substr(var.load_balancer_arn, 50, -1)],
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", substr(var.target_group_arn, 73, -1), "LoadBalancer", substr(var.load_balancer_arn, 50, -1)]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "EC2 and Health Metrics"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.database_identifier],
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.database_identifier],
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.database_identifier],
            ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", var.database_identifier],
            ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", var.database_identifier]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "Database Metrics"
          period  = 300
        }
      }
    ]
  })
}

# CloudWatch Alarms

# High CPU Utilization Alarm for EC2 instances
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.environment}-high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cpu_high_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  tags = {
    Name        = "${var.environment}-high-cpu-alarm"
    Environment = var.environment
  }
}

# Unhealthy Host Count Alarm
resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "${var.environment}-unhealthy-hosts"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = var.unhealthy_host_threshold
  alarm_description   = "This metric monitors unhealthy hosts in target group"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    TargetGroup    = substr(var.target_group_arn, 73, -1)
    LoadBalancer   = substr(var.load_balancer_arn, 50, -1)
  }

  tags = {
    Name        = "${var.environment}-unhealthy-hosts-alarm"
    Environment = var.environment
  }
}

# High Response Time Alarm
resource "aws_cloudwatch_metric_alarm" "high_response_time" {
  alarm_name          = "${var.environment}-high-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "2"  # 2 seconds
  alarm_description   = "This metric monitors application response time"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = substr(var.load_balancer_arn, 50, -1)
  }

  tags = {
    Name        = "${var.environment}-high-response-time-alarm"
    Environment = var.environment
  }
}

# Database CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "${var.environment}-database-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.database_cpu_threshold
  alarm_description   = "This metric monitors database CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.database_identifier
  }

  tags = {
    Name        = "${var.environment}-database-cpu-alarm"
    Environment = var.environment
  }
}

# Database Connection Count Alarm
resource "aws_cloudwatch_metric_alarm" "database_connections" {
  alarm_name          = "${var.environment}-database-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.database_connection_threshold
  alarm_description   = "This metric monitors database connection count"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.database_identifier
  }

  tags = {
    Name        = "${var.environment}-database-connections-alarm"
    Environment = var.environment
  }
}

# Low Free Storage Space Alarm for Database
resource "aws_cloudwatch_metric_alarm" "database_free_storage" {
  alarm_name          = "${var.environment}-database-low-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "2000000000"  # 2GB in bytes
  alarm_description   = "This metric monitors database free storage space"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.database_identifier
  }

  tags = {
    Name        = "${var.environment}-database-storage-alarm"
    Environment = var.environment
  }
}

# HTTP 5XX Error Rate Alarm
resource "aws_cloudwatch_metric_alarm" "http_5xx_errors" {
  alarm_name          = "${var.environment}-high-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors 5XX errors from the application"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = substr(var.load_balancer_arn, 50, -1)
  }

  tags = {
    Name        = "${var.environment}-5xx-errors-alarm"
    Environment = var.environment
  }
}

# Log Groups for application logs
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/ec2/${var.environment}-application"
  retention_in_days = 7

  tags = {
    Name        = "${var.environment}-application-logs"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "alb_access_logs" {
  name              = "/aws/applicationloadbalancer/${var.environment}-access-logs"
  retention_in_days = 7

  tags = {
    Name        = "${var.environment}-alb-access-logs"
    Environment = var.environment
  }
}