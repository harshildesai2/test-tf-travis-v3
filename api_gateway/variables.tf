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

variable "sendSubscriptionUpdate_invoke_arn" {
  description = "aws_lambda_function.sendSubscriptionUpdate.invoke_"
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

variable "sendSubscriptionUpdate_arn" {
  description = "aws_lambda_function.sendSubscriptionUpdate."
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

variable "certificate_domain_name" {
  description = "Domain name associated with SSL certificate to be used for API Gateway"
}
variable "route53_assume_role_arn" {
  description = "IAM role to assume when working with Route53 resources. Default: empty (do not assume role)"
  default = ""
}
variable "required_tags" {
  type = "map"
  description = "Tags to apply to all resources"
}

locals {
  apigw_domain_name = "${lower(var.env_name) == "prod" ? "preference.${var.certificate_domain_name}" : "preference-${lower(var.env_name)}.${var.certificate_domain_name}"}"
  name_prefix = "${lower(var.env_name) == "prod" ? "consentmgt" : "consentmgt-${lower(var.env_name)}"}"
  required_tags = "${var.required_tags}"
}
