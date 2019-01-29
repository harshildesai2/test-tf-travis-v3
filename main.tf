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
  code_bucket = "${var.code_bucket}"
  jar_path    = "${var.jar_path}"
  required_tags = "${local.required_tags}"
  api_endpoint  = "${api_endpoint}"
  api_password  = "${api_password}"
}

module "api_gateway" {
  source = "api_gateway"

  env_name   = "${lower(var.env_name)}"
  env_region = "${data.aws_region.current.name}"

  getSubscriber_arn = "${module.lambda.getSubscriber_arn}"
  getSubscriptionStatus_arn = "${module.lambda.getSubscriptionStatus_arn}"
  updateSubscriber_arn = "${module.lambda.updateSubscriber_arn}"
  getSubscriber_invoke_arn = "${module.lambda.getSubscriber_invoke_arn}"
  getSubscriptionStatus_invoke_arn = "${module.lambda.getSubscriptionStatus_invoke_arn}"
  updateSubscriber_invoke_arn = "${module.lambda.updateSubscriber_invoke_arn}"

  required_tags = "${local.required_tags}"
}
