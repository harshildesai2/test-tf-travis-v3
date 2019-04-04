locals {
  # Referencing ARN directly until aws_kinesis_firehose_delivery_stream data provider is added
  kinesis_firehose_delivery_stream_arn = "arn:aws:firehose:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deliverystream/${var.kinesis_firehose_delivery_stream_name}"
}

# IAM role for log subscription filter
resource "aws_iam_role" "log_subscription" {
  count              = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name               = "${local.name_prefix}-lambda-log-subscription-role"
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
  name   = "${local.name_prefix}-lambda-log-subscription-role-policy"
  role   = "${aws_iam_role.log_subscription.id}"
  policy = "${data.template_file.log_subscription.rendered}"
}
