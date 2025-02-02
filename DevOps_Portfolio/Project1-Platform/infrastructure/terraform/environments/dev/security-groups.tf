# Default VPC Security Group
resource "aws_security_group" "default" {
  name_prefix = "dev-default-sg"
  description = "Default security group for VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dev-default-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# ALB Security Group
resource "aws_security_group" "alb" {
  name_prefix = "dev-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dev-alb-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# Web Server Security Group
resource "aws_security_group" "web" {
  name_prefix = "dev-web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow HTTP from ALB"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow HTTPS from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dev-web-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}

# Database Security Group
resource "aws_security_group" "db" {
  name_prefix = "dev-db-sg"
  description = "Security group for databases"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
    description     = "Allow MySQL from web servers"
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
    description     = "Allow PostgreSQL from web servers"
  }

  tags = {
    Name        = "dev-db-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform"
  }
}
