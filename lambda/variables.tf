variable "env_name" {
  description = "Environment name [dev, qa14, qa16, stage, prod]"
}

variable "code_bucket" {
  description = "s3 bucket name for code"
}

variable "jar_path" {
  description = "path of code jar in S3 s3 bucket"
}

variable "api_endpoint" {
  description = "Token API endpoint"
}

variable "api_password" {
  description = "Token API password"
}

variable "api_username" {
  description = "Token API username"
}

variable "logs_retention_in_days" {
  description = "Number of days to keep logs in CloudWatch log groups. Default: 14"
  default = "14"
}

variable "kinesis_firehose_delivery_stream_name" {
  description = "Name of Kinesis Firehose delivery stream where to send logs. Default: empty string (no streaming)"
  default = ""
}

variable "required_tags" {
  type = "map"
  description = "Tags to apply to all resources"
}

variable "certificate_domain_name" {
  description = "Domain name associated with SSL certificate to be used for API Gateway"
}

variable "login_access_key" {
  description = "Access key for login API"
}

variable "login_secret_key" {
  description = "Secret key for login API"
}

variable "batch_size" {
  description = "No of records read per batch. Default: 10"
  default     = 10
}

variable "batch_count" {
  description = "No of batch reads per scheduler execution. Default: 5"
  default     = 5
}

variable "wait_time" {
  description = "Time waited after every batch execution. Default: 10"
  default     = 10
}

variable "update_scheduler_run_period" {
  description = "Scheduler run period in minutes. Default: 1"
  default     = 1
}

variable "queue_name" {
  description = "Name of the FIFO queue that stores Subscription messages"
}

variable "subscriber_queue_arn" {
  description = "arn for the FIFO SQS queue where subscriber messages are stored."
}

locals {
  name_prefix = "${lower(var.env_name) == "prod" ? "consentmgt" : "consentmgt-${lower(var.env_name)}"}"
  required_tags = "${var.required_tags}"
  apigw_domain_name = "${lower(var.env_name) == "prod" ? "preference.${var.certificate_domain_name}" : "preference-${lower(var.env_name)}.${var.certificate_domain_name}"}"
}
