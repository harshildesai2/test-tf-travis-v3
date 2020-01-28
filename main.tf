provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/hdesai/.aws/credentials"
  profile                 = "default"
}

module "lambda" {
  source = "lambda"

  env_name    = "${lower(var.env_name)}"
  code_bucket = "${var.code_bucket}"
  jar_path    = "${var.jar_path}"

  api_endpoint  = "${var.api_endpoint}"
  api_password  = "${var.api_password}"
  api_username  = "${var.api_username}"
  
  login_access_key = "${module.api_gateway.login_access_key}"
  login_secret_key = "${module.api_gateway.login_secret_key}"
  
  update_scheduler_run_period = "${var.update_scheduler_run_period}"
  queue_name                  = "${var.subscriber_queue_name}-${var.env_name}.fifo"
  queue_msg_id                = "${var.queue_msg_id}"
  
  certificate_domain_name = "${var.certificate_domain_name}"

  logs_retention_in_days = "${var.logs_retention_in_days}"
  kinesis_firehose_delivery_stream_name = "${var.kinesis_firehose_delivery_stream_name}"
  subscriber_queue_arn            = "${module.queue.subscriber_queue_arn}"

  required_tags = "${local.required_tags}"
}

module "api_gateway" {
  source = "api_gateway"

  env_name   = "${lower(var.env_name)}"

  login_arn                         = "${module.lambda.login_arn}"
  getSubscriber_arn                 = "${module.lambda.getSubscriber_arn}"
  getSubscriptionStatus_arn         = "${module.lambda.getSubscriptionStatus_arn}"
  sendSubscriptionUpdate_arn        = "${module.lambda.sendSubscriptionUpdate_arn}"
  login_invoke_arn                  = "${module.lambda.login_invoke_arn}"
  getSubscriber_invoke_arn          = "${module.lambda.getSubscriber_invoke_arn}"
  getSubscriptionStatus_invoke_arn  = "${module.lambda.getSubscriptionStatus_invoke_arn}"
  sendSubscriptionUpdate_invoke_arn = "${module.lambda.sendSubscriptionUpdate_invoke_arn}"
  subscriber_queue_arn              = "${module.queue.subscriber_queue_arn}"
  queue_name                        = "${var.subscriber_queue_name}-${var.env_name}.fifo"

  certificate_domain_name = "${var.certificate_domain_name}"  

  logs_retention_in_days = "14"
  kinesis_firehose_delivery_stream_name = "${var.kinesis_firehose_delivery_stream_name}"

  required_tags = "${local.required_tags}"
}

module "usage_plan" {
  source = "usage_plan"

  env_name   = "${lower(var.env_name)}"
  stage_name = "${module.api_gateway.stage_name}"

  api_resource_id = "${module.api_gateway.api_resource_id}"
}

module "queue" {
  source = "queue"

  env_name                = "${lower(var.env_name)}"
  queue_name              = "${var.subscriber_queue_name}-${var.env_name}.fifo"
  dead_letter_queue_name  = "${var.subscriber_queue_name}Dead-${var.env_name}.fifo"

  required_tags = "${local.required_tags}"
}
