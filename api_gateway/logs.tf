locals {
  # Referencing ARN directly until aws_kinesis_firehose_delivery_stream data provider is added
  kinesis_firehose_delivery_stream_arn = "arn:aws:firehose:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.kinesis_firehose_delivery_stream_name}"
}

# Log group to store API Gateway access logs
resource "aws_cloudwatch_log_group" "apigw_access_logs" {
  name              = "API-Gateway-Access-Logs_${aws_api_gateway_rest_api.consent_mgt.id}"
  retention_in_days = "${var.logs_retention_in_days}"
  tags              = "${local.required_tags}"
}

# Log group to store API Gateway execution logs
resource "aws_cloudwatch_log_group" "apigw_exec_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.consent_mgt.id}/v1"
  retention_in_days = "${var.logs_retention_in_days}"
  tags              = "${local.required_tags}"
}

resource "aws_cloudwatch_log_subscription_filter" "apigw_access_logs" {
  count           = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name            = "${local.name_prefix}-apigw-access-logfilter"
  role_arn        = "${aws_iam_role.log_subscription.arn}"
  log_group_name  = "${aws_cloudwatch_log_group.apigw_access_logs.name}"
  destination_arn = "${local.kinesis_firehose_delivery_stream_arn}"
  distribution    = "ByLogStream"
  filter_pattern  = ""
}

resource "aws_cloudwatch_log_subscription_filter" "apigw_exec_logs" {
  count           = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name            = "${local.name_prefix}-apigw-exec-logfilter"
  role_arn        = "${aws_iam_role.log_subscription.arn}"
  log_group_name  = "${aws_cloudwatch_log_group.apigw_exec_logs.name}"
  destination_arn = "${local.kinesis_firehose_delivery_stream_arn}"
  distribution    = "ByLogStream"
  filter_pattern  = ""
}

# IAM role for log subscription filter
resource "aws_iam_role" "log_subscription" {
  count              = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name               = "${local.name_prefix}-apigw-log-subscription-role"
  assume_role_policy = "${file("${path.module}/templates/log_subscription_role.json.tpl")}"
}

# Render log subscription policy from a template
data "template_file" "log_subscription" {
  template = "${file("${path.module}/templates/log_subscription_role_policy.json.tpl")}"
  vars {
    kinesis_firehose_delivery_stream_arn = "${local.kinesis_firehose_delivery_stream_arn}"
  }
}

# Let log subscription push logs to Firehose delivery stream
resource "aws_iam_role_policy" "log_subscription" {
  count  = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name   = "${local.name_prefix}-apigw-log-subscription-role-policy"
  role   = "${aws_iam_role.log_subscription.id}"
  policy = "${data.template_file.log_subscription.rendered}"
}
