variable "env_name" {
  description = "Environment name [dev, qa14, qa16, stage, prod]"
}

variable "env_region" {
  description = "aws_region"
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

variable "login_secretkey" {
  description = "key for the login API"
}

variable "login_accesskey" {
  description = "access key for login API"
}

locals {
  name_prefix = "${lower(var.env_name) == "prod" ? "consentmgt" : "consentmgt-${lower(var.env_name)}"}"
  required_tags = "${var.required_tags}"
  apigw_domain_name = "${lower(var.env_name) == "prod" ? "preference.${var.certificate_domain_name}" : "preference-${lower(var.env_name)}.${var.certificate_domain_name}"}"
}
