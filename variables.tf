variable "env_name" {
  description = "Environment name [dev, qa, stage, prod]"
}

variable "env_tag" {
  description = "Environment name for tagging [dev, qa, stg, prod]"
  default = ""
}

variable "code_bucket" {
  description = "S3 bucket name for code"
  default = "lll-responsys-consentmgt"
}

variable "jar_path" {
  description = "Path of code JAR in S3 bucket"
  default = "code/consentmgtapi-1.0.1.jar"
}

variable "subscriber_queue_name" {
  description = "Name of the FIFO queue for posting the subscription messages"
  default = "subscriberMsgQueue"
}

variable "queue_msg_id" {
  description = "MessageId used for the messages sent to the FIFO queue"
  default = "subscriberMsg"
}

variable "update_scheduler_run_period" {
  description = "Scheduler run period in minutes. Default: 1"
  default     = 1
}

variable "logs_retention_in_days" {
  description = "Number of days to keep logs in CloudWatch log groups. Default: 14"
  default = "14"
}
variable "kinesis_firehose_delivery_stream_name" {
  description = "Name of Kinesis Firehose delivery stream where to send logs. Default: empty string (no streaming)"
  default = ""
}
variable "api_cloudwatch_log_level" {
  description = "CloudWatch log level for Rest API stage [OFF, ERROR, INFO]. Default: INFO"
  default = "INFO"
}

variable "api_data_trace_enabled" {
  description = "Specifies whether data trace logging is enabled for all methods, if true API Gateway pushes logs to CloudWatch. Default: false"
  default = "false"
}

variable "certificate_domain_name" {
  description = "Domain name associated with SSL certificate to be used for API Gateway"
  default = "asdf"
}


variable "api_endpoint" {
  description = "Token API endpoint"
  default = "https://login2.responsys.net/rest/api/v1/auth/token"
}

variable "api_password" {
  description = "Token API password"
  default = "Lulu%40lem0n"
}

variable "api_username" {
  description = "Token API username"
  default = "loyalty_API"
}


locals {
  required_tags = {
    "lll:deployment:environment"    = "${var.env_tag == "" ? lower(var.env_name) : lower(var.env_tag)}"
    "lll:deployment:terraform"      = "True"
    "lll:business:application-name" = "Consent Management"
  }
}
