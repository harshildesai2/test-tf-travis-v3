provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/hdesai/.aws/credentials"
  profile                 = "default"
}

# Retrieve information about current region
data "aws_region" "current" {}

module "lambda" {
  source = "lambda"

  env_name    = "${lower(var.env_name)}"
  env_region = "${data.aws_region.current.name}"
  code_bucket = "${var.code_bucket}"
  jar_path    = "${var.jar_path}"

  api_endpoint  = "https://login2.responsys.net/rest/api/v1/auth/token"
  api_password  = "password"
  api_username  = "Lulu%40lem0n"

  certificate_domain_name = "${var.certificate_domain_name}"
  logs_retention_in_days = "${var.logs_retention_in_days}"
  kinesis_firehose_delivery_stream_name = "${var.kinesis_firehose_delivery_stream_name}"

  required_tags = "${local.required_tags}"
  login_secretkey = "${module.api_gateway.login_secretkey}"
  login_accesskey = "${module.api_gateway.login_accesskey}"
}

module "api_gateway" {
  source = "api_gateway"

  env_name   = "${lower(var.env_name)}"
  env_region = "${data.aws_region.current.name}"

  login_arn = "${module.lambda.login_arn}"
  getSubscriber_arn = "${module.lambda.getSubscriber_arn}"
  getSubscriptionStatus_arn = "${module.lambda.getSubscriptionStatus_arn}"
  updateSubscriber_arn = "${module.lambda.updateSubscriber_arn}"
  login_invoke_arn = "${module.lambda.login_invoke_arn}"
  getSubscriber_invoke_arn = "${module.lambda.getSubscriber_invoke_arn}"
  getSubscriptionStatus_invoke_arn = "${module.lambda.getSubscriptionStatus_invoke_arn}"
  updateSubscriber_invoke_arn = "${module.lambda.updateSubscriber_invoke_arn}"
  logs_retention_in_days = "14"
  kinesis_firehose_delivery_stream_name = "${var.kinesis_firehose_delivery_stream_name}"
  
  required_tags = "${local.required_tags}"
}

module "usage_plan" {

  source      = "usage_plan"
  env_name    = "${lower(var.env_name)}"
  stage_name  = "${module.api_gateway.stage_name}"
  api_resource_id = "${module.api_gateway.api_resource_id}"

}
