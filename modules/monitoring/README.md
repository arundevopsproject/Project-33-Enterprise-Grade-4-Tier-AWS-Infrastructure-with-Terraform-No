# Monitoring Module

This module provides comprehensive CloudWatch monitoring and alerting for your web application infrastructure.

## Features

### 📊 CloudWatch Dashboard
- **Load Balancer Metrics**: Request count, response time, HTTP status codes
- **Auto Scaling Metrics**: Group capacity, in-service instances, scaling events
- **EC2 & Health Metrics**: CPU utilization, healthy/unhealthy host counts
- **Database Metrics**: CPU utilization, connections, storage, read/write latency

### 🚨 CloudWatch Alarms
- **High CPU Utilization**: Triggers when EC2 instances exceed CPU threshold
- **Unhealthy Hosts**: Alerts when target group has unhealthy instances
- **High Response Time**: Monitors application response time (>2 seconds)
- **Database CPU**: Monitors RDS CPU utilization
- **Database Connections**: Tracks database connection count
- **Low Storage Space**: Alerts when RDS free storage is low (<2GB)
- **HTTP 5XX Errors**: Monitors application errors

### 📧 SNS Notifications
- Configurable email notifications for all alarms
- Supports both alarm and OK state notifications

### 📝 CloudWatch Logs
- Application log group: `/aws/ec2/{environment}-application`
- ALB access logs: `/aws/applicationloadbalancer/{environment}-access-logs`

## Usage

```hcl
module "monitoring" {
  source = "../../modules/monitoring"
  
  environment = var.environment
  
  # Required resource identifiers
  autoscaling_group_name = module.compute.autoscaling_group_name
  load_balancer_arn      = module.compute.load_balancer_arn
  target_group_arn       = module.compute.target_group_arn
  database_identifier    = module.database.database_identifier
  
  # Optional: Email notifications
  notification_email = "admin@yourcompany.com"
  
  # Customizable thresholds
  cpu_high_threshold         = 80
  cpu_low_threshold          = 20
  database_cpu_threshold     = 75
  database_connection_threshold = 50
  unhealthy_host_threshold   = 1
}
```

## Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `environment` | Environment name | `string` | Required |
| `project_name` | Name of the project | `string` | `"web-platform"` |
| `autoscaling_group_name` | ASG name to monitor | `string` | Required |
| `load_balancer_arn` | ALB ARN to monitor | `string` | Required |
| `target_group_arn` | Target Group ARN to monitor | `string` | Required |
| `database_identifier` | RDS identifier to monitor | `string` | Required |
| `notification_email` | Email for alerts | `string` | `""` |
| `cpu_high_threshold` | CPU threshold for scaling up | `number` | `80` |
| `cpu_low_threshold` | CPU threshold for scaling down | `number` | `20` |
| `database_cpu_threshold` | Database CPU threshold | `number` | `75` |
| `database_connection_threshold` | DB connection threshold | `number` | `50` |
| `unhealthy_host_threshold` | Unhealthy host count threshold | `number` | `1` |

## Outputs

| Output | Description |
|--------|-------------|
| `sns_topic_arn` | ARN of the SNS topic for alerts |
| `dashboard_url` | URL of the CloudWatch dashboard |
| `dashboard_name` | Name of the CloudWatch dashboard |
| `alarm_names` | List of all created alarm names |
| `log_group_names` | Names of created log groups |

## Environment-Specific Configurations

### Development Environment
- Higher CPU thresholds (85% high, 10% low)
- Less strict database monitoring (80% CPU)
- 7-day log retention

### Production Environment
- Lower CPU thresholds (70% high, 15% low)
- Stricter database monitoring (70% CPU)
- More connection monitoring (80 connections)
- Enhanced alerting sensitivity

## Dashboard Sections

1. **Load Balancer Metrics**
   - Request count and response time
   - HTTP 2XX and 5XX response codes

2. **Auto Scaling Group Metrics**
   - Desired, in-service, min, and max capacity
   - Scaling events and health status

3. **EC2 and Health Metrics**
   - CPU utilization by ASG
   - Healthy and unhealthy host counts

4. **Database Metrics**
   - CPU utilization and connection count
   - Storage space and I/O latency

## Alarm Actions

All alarms are configured to:
- Send notifications to the SNS topic when triggered
- Send notifications when returning to OK state
- Use appropriate evaluation periods and statistics
- Include meaningful descriptions and tags

## Best Practices

1. **Email Notifications**: Set up a team email or distribution list
2. **Threshold Tuning**: Adjust thresholds based on your application's normal behavior
3. **Regular Review**: Monitor alarm frequency and adjust thresholds as needed
4. **Dashboard Usage**: Use the dashboard URL for real-time monitoring
5. **Log Analysis**: Leverage CloudWatch Logs Insights for detailed analysis

## Related Resources

- [CloudWatch Dashboard Console](https://console.aws.amazon.com/cloudwatch/home#dashboards:)
- [CloudWatch Alarms Console](https://console.aws.amazon.com/cloudwatch/home#alarmsV2:)
- [SNS Topics Console](https://console.aws.amazon.com/sns/v3/home#/topics)
- [CloudWatch Logs Console](https://console.aws.amazon.com/cloudwatch/home#logsV2:)
