# Gateway Endpoints (Free)

# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private.id,
    aws_route_table.public.id
  ]

  tags = {
    Name        = "dev-s3-endpoint"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private.id,
    aws_route_table.public.id
  ]

  tags = {
    Name        = "dev-dynamodb-endpoint"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# Interface Endpoints (Paid)

# Security Group for Interface Endpoints
resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "dev-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
    description     = "HTTPS from web servers"
  }

  tags = {
    Name        = "dev-vpc-endpoints-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# ECR API Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "dev-ecr-api-endpoint"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# ECR DKR Endpoint (for Docker registry)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "dev-ecr-dkr-endpoint"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# Systems Manager Endpoint
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "dev-ssm-endpoint"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}
