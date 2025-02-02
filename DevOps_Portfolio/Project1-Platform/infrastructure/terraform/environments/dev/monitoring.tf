# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "vpc-flow-logs-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs" {
  name = "vpc-flow-logs-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "vpc-flow-logs-role-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# IAM Policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_logs" {
  name = "vpc-flow-logs-policy-${var.environment}"
  role = aws_iam_role.vpc_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect = "Allow"
        Resource = "${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"
      }
    ]
  })
}

# Enable VPC Flow Logs
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  tags = {
    Name        = "vpc-flow-logs-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# CloudWatch Metric Alarm for VPC Endpoint Errors
resource "aws_cloudwatch_metric_alarm" "vpc_endpoint_errors" {
  alarm_name          = "vpc-endpoint-errors-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "EndpointConnectivityIssues"
  namespace           = "AWS/VPC"
  period             = "300"
  statistic          = "Sum"
  threshold          = "1"
  alarm_description  = "This metric monitors VPC endpoint connectivity issues"
  alarm_actions      = [] # Add SNS topic ARN here when available

  dimensions = {
    VpcEndpointId = aws_vpc_endpoint.s3.id
  }

  tags = {
    Name        = "vpc-endpoint-errors-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}
