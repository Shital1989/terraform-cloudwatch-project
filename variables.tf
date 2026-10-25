
variable "project_name" {
  description = "Terraform project name"
  type        = string
  default     = "terraform-cloud-watch"
}

variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "alert_email" {
  description = "Email address for SNS notifications"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization alarm threshold"
  type        = number
  default     = 70
}
