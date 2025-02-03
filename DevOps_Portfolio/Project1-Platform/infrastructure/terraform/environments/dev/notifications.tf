# SNS Topic for Infrastructure Alerts
resource "aws_sns_topic" "infrastructure_alerts" {
  name = "infrastructure-alerts-${var.environment}"

  tags = {
    Name        = "infrastructure-alerts-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "infrastructure_alerts" {
  arn = aws_sns_topic.infrastructure_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.infrastructure_alerts.arn
      }
    ]
  })
}

# NAT Gateway Error Alarm
resource "aws_cloudwatch_metric_alarm" "nat_gateway_errors" {
  alarm_name          = "nat-gateway-errors-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NATGateway"
  period             = "300"
  statistic          = "Sum"
  threshold          = "1"
  alarm_description  = "This metric monitors NAT Gateway port allocation errors"
  alarm_actions      = [aws_sns_topic.infrastructure_alerts.arn]

  dimensions = {
    NatGatewayId = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "nat-gateway-errors-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# VPC Flow Logs Delivery Error Alarm
resource "aws_cloudwatch_metric_alarm" "flow_logs_delivery" {
  alarm_name          = "flow-logs-delivery-errors-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DeliveryErrors"
  namespace           = "AWS/CloudWatch/Logs"
  period             = "300"
  statistic          = "Sum"
  threshold          = "1"
  alarm_description  = "This metric monitors VPC Flow Logs delivery errors"
  alarm_actions      = [aws_sns_topic.infrastructure_alerts.arn]

  dimensions = {
    LogGroupName = aws_cloudwatch_log_group.vpc_flow_logs.name
  }

  tags = {
    Name        = "flow-logs-delivery-errors-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}
