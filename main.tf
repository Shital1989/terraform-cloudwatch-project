
# SNS topic for notifications
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

# Email subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch alarm for EC2 CPU utilization
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name = "${var.project_name}-cpu-alarm"

  alarm_description = "Alert when EC2 CPU usage is high"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  # Avoid treating missing EC2 metrics as high CPU
  treat_missing_data = "notBreaching"

  tags = {
    Project = var.project_name
  }
}
resource "aws_instance" "app" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t3.micro"

  tags = {
    Name    = "${var.project_name}-ec2"
    Project = var.project_name
  }
}
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}