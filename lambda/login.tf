locals {
  login_function_name = "login-${var.env_name}"
}

#log Group
resource "aws_cloudwatch_log_group" "login" {
  name = "/aws/lambda/${local.login_function_name}"
  retention_in_days = "${var.logs_retention_in_days}"

  tags = "${local.required_tags}"
}

resource "aws_cloudwatch_log_subscription_filter" "login" {
  count           = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name            = "${local.name_prefix}-login-logfilter"
  role_arn        = "${aws_iam_role.log_subscription.arn}"
  log_group_name  = "${aws_cloudwatch_log_group.login.name}"
  destination_arn = "${local.kinesis_firehose_delivery_stream_arn}"
  distribution    = "ByLogStream"
  filter_pattern  = ""
}

#role for lambda execution
resource "aws_iam_role" "login" {
  name = "login-role-${var.env_name}"
  assume_role_policy = "${file("${path.module}/templates/assume_role_policy.json.tpl")}"
}

#Parsing policy file
data "template_file" "login_policy" {
  template = "${file("${path.module}/templates/get_consentmgt_policy.json.tpl")}"

  vars {
    log_group  = "${aws_cloudwatch_log_group.login.name}"
  }
}

#building policy document
resource "aws_iam_policy" "login" {
  name = "login-policy-${var.env_name}"
  path = "/"
  description = "IAM policy for ${local.login_function_name} lambda function"
  policy = "${data.template_file.login_policy.rendered}"
}

#Attaching policy to role
resource "aws_iam_role_policy_attachment" "login" {
  role = "${aws_iam_role.login.name}"
  policy_arn = "${aws_iam_policy.login.arn}"
}

#Lambda function description
resource "aws_lambda_function" "login" {
  function_name = "${local.login_function_name}"

  s3_bucket         = "${data.aws_s3_bucket_object.lambda.bucket}"
  s3_key            = "${data.aws_s3_bucket_object.lambda.key}"
  s3_object_version = "${data.aws_s3_bucket_object.lambda.version_id}"

  handler = "com.amazonaws.lambda.responsys.LoginHandler::handleRequest"
  role    = "${aws_iam_role.login.arn}"

  runtime     = "java8"
  memory_size = "512"
  timeout     = "15"

  environment {
    variables = {
      RESPONSYS_AUTH_TYPE = "password"
      RESPONSYS_PASSWORD  = "${var.api_password}"
      RESPONSYS_AUTH_TOKEN_ENDPOINT = "${var.api_endpoint}"
      RESPONSYS_USERNAME  = "${var.api_username}"
    }
  }

  tags = "${local.required_tags}"
}
