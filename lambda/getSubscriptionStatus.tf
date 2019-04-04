locals {
  getSubscriptionStatus_function_name = "getSubscriptionStatus-${var.env_name}"
}

#log Group
resource "aws_cloudwatch_log_group" "getSubscriptionStatus" {
  name = "/aws/lambda/${local.getSubscriptionStatus_function_name}"
  retention_in_days = "${var.logs_retention_in_days}"

  tags = "${local.required_tags}"
}

resource "aws_cloudwatch_log_subscription_filter" "getSubscriptionStatus" {
  count           = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name            = "${local.name_prefix}-getSubscriptionStatus-logfilter"
  role_arn        = "${aws_iam_role.log_subscription.arn}"
  log_group_name  = "${aws_cloudwatch_log_group.getSubscriptionStatus.name}"
  destination_arn = "${local.kinesis_firehose_delivery_stream_arn}"
  distribution    = "ByLogStream"
  filter_pattern  = ""
}

#role for lambda execution
resource "aws_iam_role" "getSubscriptionStatus" {
  name = "getSubscriptionStatus-role-${var.env_name}"
  assume_role_policy = "${file("${path.module}/templates/assume_role_policy.json.tpl")}"
}

#Parsing policy file
data "template_file" "getSubscriptionStatus_policy" {
  template = "${file("${path.module}/templates/get_consentmgt_policy.json.tpl")}"

  vars {
    log_group  = "${aws_cloudwatch_log_group.getSubscriptionStatus.name}"
  }
}

#building policy document
resource "aws_iam_policy" "getSubscriptionStatus" {
  name = "getSubscriptionStatus-policy-${var.env_name}"
  path = "/"
  description = "IAM policy for ${local.getSubscriptionStatus_function_name} lambda function"
  policy = "${data.template_file.getSubscriptionStatus_policy.rendered}"
}

#Attaching policy to role
resource "aws_iam_role_policy_attachment" "getSubscriptionStatus" {
  role = "${aws_iam_role.getSubscriptionStatus.name}"
  policy_arn = "${aws_iam_policy.getSubscriptionStatus.arn}"
}

#Lambda function description
resource "aws_lambda_function" "getSubscriptionStatus" {
  function_name = "${local.getSubscriptionStatus_function_name}"

  s3_bucket = "${var.code_bucket}"
  s3_key    = "${var.jar_path}"

  handler = "com.amazonaws.lambda.responsys.GetSubscriberInfoHandler::handleRequest"
  role    = "${aws_iam_role.getSubscriptionStatus.arn}"

  runtime     = "java8"
  memory_size = "512"
  timeout     = "15"

  environment {
    variables = {
      AUTH_TYPE = "password"
      PASSWORD  = "Lulu%40lem0n"
      RESPONSYS_AUTH_TOKEN_ENDPOINT = "https://login2.responsys.net/rest/api/v1/auth/token"
      USERNAME  = "loyalty_API"
      GET_MEMBER_API_URL  = "/rest/api/v1/lists/CONTACTS_LIST/members/"
      GET_FIELD_PARAMS = "EMAIL_ADDRESS_,EMAIL_PERMISSION_STATUS_"
      IS_TRANSFORM_RESPONSE = "true"
    }
  }

  tags = "${local.required_tags}"
}
