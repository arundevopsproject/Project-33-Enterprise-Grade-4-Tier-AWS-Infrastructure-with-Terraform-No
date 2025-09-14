# Monitoring module outputs

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = "https://${data.aws_region.current.name}.console.aws.amazon.com/cloudwatch/home?region=${data.aws_region.current.name}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "alarm_names" {
  description = "Names of all created CloudWatch alarms"
  value = [
    aws_cloudwatch_metric_alarm.high_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.unhealthy_hosts.alarm_name,
    aws_cloudwatch_metric_alarm.high_response_time.alarm_name,
    aws_cloudwatch_metric_alarm.database_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.database_connections.alarm_name,
    aws_cloudwatch_metric_alarm.database_free_storage.alarm_name,
    aws_cloudwatch_metric_alarm.http_5xx_errors.alarm_name
  ]
}

output "log_group_names" {
  description = "Names of created CloudWatch log groups"
  value = [
    aws_cloudwatch_log_group.application_logs.name,
    aws_cloudwatch_log_group.alb_access_logs.name
  ]
}