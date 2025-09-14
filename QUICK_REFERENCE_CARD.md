# 🚀 Terraform Web Infrastructure - Quick Reference Card

## **Project Summary**
**Complete AWS infrastructure with 4 modules, 2 environments, and 43 resources**

---

## **📁 Directory Structure**
```
terraform-web-platform/
├── environments/
│   ├── dev/           # Development (us-east-1, t3.micro)
│   └── prod/          # Production (us-west-2, t3.large)
└── modules/
    ├── networking/    # VPC, subnets, security groups
    ├── compute/       # ALB, ASG, EC2
    ├── database/      # RDS MySQL
    └── monitoring/    # CloudWatch, SNS, alarms
```

---

## **⚡ Quick Commands**

### **Deploy Development Environment**
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
terraform output load_balancer_dns
```

### **Deploy Production Environment**
```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

### **View Monitoring**
```bash
terraform output dashboard_url
terraform output monitoring_alarms
```

### **Cleanup**
```bash
terraform destroy  # Always confirm carefully!
```

---

## **🏗️ Architecture Summary**

### **Resource Count by Module**
- **Networking**: 13 resources (VPC, subnets, gateways, security groups)
- **Compute**: 7 resources (ALB, ASG, launch template, policies)
- **Database**: 3 resources (RDS, parameter group, subnet group)
- **Monitoring**: 10+ resources (dashboard, alarms, SNS, logs)

### **Network Design**
```
VPC: 10.0.0.0/16 (dev) | 10.1.0.0/16 (prod)
├── Public Subnets: 10.x.1.0/24, 10.x.2.0/24
└── Private Subnets: 10.x.11.0/24, 10.x.12.0/24
```

---

## **📊 Monitoring Quick Reference**

### **7 CloudWatch Alarms**
1. **High CPU** (>80%) → Auto-scale up
2. **Unhealthy Hosts** (≥1) → Health alert
3. **Slow Response** (>2s) → Performance alert
4. **Database CPU** (>75%) → DB alert
5. **DB Connections** (>50) → Connection alert
6. **Low Storage** (<2GB) → Storage alert
7. **5XX Errors** (>10/5min) → Error alert

### **Dashboard Sections**
- 🌐 Load Balancer: Requests, response time, status codes
- ⚙️ Auto Scaling: Capacity, instances, health
- 🔥 EC2: CPU utilization, scaling events
- 🗄️ Database: CPU, connections, storage, latency

---

## **🔒 Security Configuration**

### **Security Group Rules**
```
Web Tier SG: 0.0.0.0/0 → :80,:443
App Tier SG: Web SG → :80 | VPC CIDR → :22
DB Tier SG: App SG → :3306
```

### **Network Isolation**
- **Public**: ALB only
- **Private**: EC2 instances and RDS
- **NAT Gateways**: Provide outbound internet for private subnets

---

## **🌍 Environment Differences**

| **Setting** | **Dev** | **Prod** |
|-------------|---------|----------|
| **Region** | us-east-1 | us-west-2 |
| **Instance** | t3.micro | t3.large |
| **ASG Min/Max** | 1/3 | 2/10 |
| **Database** | db.t3.micro, Single AZ | db.t3.medium, Multi-AZ |
| **Backup Days** | 7 | 30 |
| **CPU Threshold** | 85%/10% | 70%/15% |

---

## **💰 Cost Estimation**

### **Development Environment**
- **EC2**: ~$8.50/month (1 t3.micro)
- **RDS**: ~$15/month (db.t3.micro)
- **ALB**: ~$16/month
- **NAT Gateway**: ~$45/month
- **CloudWatch**: ~$10/month
- **Total**: ~$95/month

### **Production Environment**
- **EC2**: ~$135/month (2 t3.large)
- **RDS**: ~$60/month (db.t3.medium, Multi-AZ)
- **ALB**: ~$16/month
- **NAT Gateway**: ~$90/month (2 gateways)
- **CloudWatch**: ~$20/month
- **Total**: ~$320/month

---

## **🔧 Common Variables**

### **Required Variables**
```hcl
environment = "dev" | "prod"
aws_region = "us-east-1" | "us-west-2"
db_password = "SecurePassword123!"
```

### **Optional Variables**
```hcl
notification_email = "admin@company.com"
instance_type = "t3.micro" | "t3.large"
min_size = 1 | 2
max_size = 3 | 10
desired_capacity = 2 | 4
```

---

## **🚨 Troubleshooting**

### **Common Issues**
```bash
# State lock issue
terraform force-unlock <lock-id>

# Permission errors
aws sts get-caller-identity  # Check identity
aws iam get-user            # Check permissions

# Resource conflicts
terraform import <resource> <aws-id>

# Plan differences
terraform refresh
```

### **Validation Commands**
```bash
# Check Terraform syntax
terraform validate

# Check AWS connectivity
aws ec2 describe-vpcs

# Test application
curl -I http://$(terraform output -raw load_balancer_dns)
```

---

## **📖 Key Outputs**

### **After Deployment**
```bash
# Application access
load_balancer_dns = "app-alb-dev-123456789.us-east-1.elb.amazonaws.com"

# Monitoring
dashboard_url = "https://console.aws.amazon.com/cloudwatch/..."
sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:dev-alerts"

# Infrastructure IDs
vpc_id = "vpc-0123456789abcdef0"
database_endpoint = "dev-mysql-db.xyz.us-east-1.rds.amazonaws.com"
```

---

## **🎯 Testing Checklist**

### **Post-Deployment Tests**
- [ ] Application loads via ALB URL
- [ ] CloudWatch dashboard shows metrics
- [ ] All 7 alarms are in OK state
- [ ] SNS topic subscription confirmed
- [ ] Database connectivity from EC2
- [ ] Auto-scaling triggers on high CPU
- [ ] Instance replacement on termination

### **Security Validation**
- [ ] EC2 instances not directly accessible
- [ ] Database only accessible from app tier
- [ ] Security groups follow least privilege
- [ ] RDS encryption enabled
- [ ] CloudTrail logging active

---

## **🚀 Next Steps**

### **Immediate Actions**
1. Deploy to your AWS sandbox account
2. Customize monitoring thresholds
3. Add your email for notifications

### **Advanced Enhancements**
1. Add HTTPS with ACM certificates
2. Implement CI/CD with GitHub Actions
3. Add container support with ECS
4. Enable cross-region disaster recovery

---

## **📞 Support & Resources**

### **Documentation**
- 📁 [Project README](./README.md)
- 📊 [Monitoring Guide](./modules/monitoring/README.md)
- 🎯 [Full Presentation](./PRESENTATION_REPORT.md)

### **AWS Console Links**
- [CloudWatch Dashboards](https://console.aws.amazon.com/cloudwatch/home#dashboards:)
- [EC2 Auto Scaling](https://console.aws.amazon.com/ec2/autoscaling/home)
- [RDS Instances](https://console.aws.amazon.com/rds/home)
- [Load Balancers](https://console.aws.amazon.com/ec2/v2/home#LoadBalancers:)

---

*Keep this reference card handy for quick access to commands and configurations!*
