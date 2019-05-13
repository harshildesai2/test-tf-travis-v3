variable "env_name" {
  description = "Environment name [dev, qa14,qa16, stage, prod]"
}

variable "queue_name" {
  description = "Name of the FIFO queue for posting the subscription messages"
}

variable "login_invoke_arn" {
  description = "aws_lambda_function.login.invoke_"
}

variable "getSubscriber_invoke_arn" {
  description = "aws_lambda_function.getSubscriber.invoke_"
}

variable "getSubscriptionStatus_invoke_arn" {
  description = "aws_lambda_function.getSubscriptionStatus.invoke_"
}

variable "login_arn" {
  description = "aws_lambda_function.login."
}

variable "getSubscriber_arn" {
  description = "aws_lambda_function.getSubscriber."
}

variable "getSubscriptionStatus_arn" {
  description = "aws_lambda_function.getSubscriptionStatus."
}

variable "subscriber_queue_arn" {
  description = "arn for the FIFO SQS queue where subscriber messages are stored."
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
variable "required_tags" {
  type = "map"
  description = "Tags to apply to all resources"
}

locals {
  apigw_domain_name = "preference.domain"
  name_prefix = "${lower(var.env_name) == "prod" ? "consentmgt" : "consentmgt-${lower(var.env_name)}"}"
  required_tags = "${var.required_tags}"
}
