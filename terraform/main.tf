resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "dee-store-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "dee-store-igw" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = { Name = "dee-store-public-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "dee-store-public-rt" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ==================== Security Group ====================

resource "aws_security_group" "ec2_sg" {
  name        = "dee-store-sg1"
  vpc_id      = aws_vpc.main.id
  description = "Security group for Dee Store"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "dee-store-sg" }
}

# ==================== IAM Role for CloudWatch ====================

resource "aws_iam_role" "cloudwatch_agent" {
  name = "dee-store-cloudwatch-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.cloudwatch_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cloudwatch" {
  name = "dee-store-cloudwatch-profile"
  role = aws_iam_role.cloudwatch_agent.name
}

# ==================== EC2 Instance ====================
resource "aws_instance" "dee_store" {
  ami = "ami-0c42fad2ea005202d"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "dee-store-key"
  user_data_replace_on_change = true
  
  user_data = <<-EOF
                #!/bin/bash
                set -e
                
                # Update and install Docker using dnf (Amazon Linux)
                dnf update -y
                dnf install -y docker
                systemctl start docker
                systemctl enable docker  
                EOF

  tags = {
    Name = "dee-store-app"
  }  
}
# ==================== CloudWatch Logs ====================

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/dee-store/app-logs"
  retention_in_days = 30

  tags = {
    Name        = "dee-store-app-logs"
    Environment = "production"
  }
}

resource "aws_cloudwatch_log_group" "nginx_logs" {
  name              = "/dee-store/nginx-logs"
  retention_in_days = 14

  tags = { Name = "dee-store-nginx-logs" }
}

# ==================== CloudWatch Alarms ====================

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "dee-store-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "High CPU Usage on Dee Store Server"

  dimensions = {
    InstanceId = aws_instance.dee_store.id
  }
}

resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "dee-store-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "High Memory Usage on Dee Store Server"

  dimensions = {
    InstanceId = aws_instance.dee_store.id
  }
}
