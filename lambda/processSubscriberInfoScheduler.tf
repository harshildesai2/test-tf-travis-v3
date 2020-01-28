locals {
  processSubscriberUpdateScheduler_function_name = "processSubscriberUpdateScheduler-${var.env_name}"
}

#log Group
resource "aws_cloudwatch_log_group" "processSubscriberUpdateScheduler" {
  name = "/aws/lambda/${local.processSubscriberUpdateScheduler_function_name}"
  retention_in_days = "${var.logs_retention_in_days}"

  tags = "${local.required_tags}"
}

resource "aws_cloudwatch_log_subscription_filter" "processSubscriberUpdateScheduler" {
  count           = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"
  name            = "${local.name_prefix}-processSubscriberUpdateScheduler-logfilter"
  role_arn        = "${aws_iam_role.log_subscription.arn}"
  log_group_name  = "${aws_cloudwatch_log_group.processSubscriberUpdateScheduler.name}"
  destination_arn = "${local.kinesis_firehose_delivery_stream_arn}"
  distribution    = "ByLogStream"
  filter_pattern  = ""
}

#role for lambda execution
resource "aws_iam_role" "processSubscriberUpdateScheduler" {
  name = "processSubscriberUpdateScheduler-role-${var.env_name}"
  assume_role_policy = "${file("${path.module}/templates/assume_role_policy.json.tpl")}"
}

#Parsing policy file
data "template_file" "processSubscriberUpdateScheduler_policy" {
  template = "${file("${path.module}/templates/get_queue_update_policy.json.tpl")}"

  vars {
    log_group             = "${aws_cloudwatch_log_group.processSubscriberUpdateScheduler.name}"
    subscriber_queue_arn  = "${var.subscriber_queue_arn}"
  }
}

#building policy document
resource "aws_iam_policy" "processSubscriberUpdateScheduler" {
  name = "processSubscriberUpdateScheduler-policy-${var.env_name}"
  path = "/"
  description = "IAM policy for ${local.processSubscriberUpdateScheduler_function_name} lambda function"
  policy = "${data.template_file.processSubscriberUpdateScheduler_policy.rendered}"
}

#Attaching policy to role
resource "aws_iam_role_policy_attachment" "processSubscriberUpdateScheduler" {
  role = "${aws_iam_role.processSubscriberUpdateScheduler.name}"
  policy_arn = "${aws_iam_policy.processSubscriberUpdateScheduler.arn}"
}

#Lambda function description
resource "aws_lambda_function" "processSubscriberUpdateScheduler" {
  function_name = "${local.processSubscriberUpdateScheduler_function_name}"

  s3_bucket         = "${data.aws_s3_bucket_object.lambda.bucket}"
  s3_key            = "${data.aws_s3_bucket_object.lambda.key}"
  s3_object_version = "${data.aws_s3_bucket_object.lambda.version_id}"

  handler = "com.amazonaws.lambda.responsys.scheduler.ProcessSubscriberUpdateScheduler::handleRequest"
  role    = "${aws_iam_role.processSubscriberUpdateScheduler.arn}"

  runtime     = "java8"
  memory_size = "512"
  timeout     = "75"

  environment {
    variables = {
      LOGIN_ENDPOINT    = "https://${local.apigw_domain_name}/login"
      LOGIN_ACCESS_KEY  = "${var.login_access_key}"
      LOGIN_SECRET_KEY  = "${var.login_secret_key}"
      LOGIN_REGION      = "${data.aws_region.current.name}"
      LOGIN_SERVICE     = "execute-api"
      UPDATE_API_URL    = "/rest/api/v1/lists/CONTACTS_LIST/members"
      MERGE_RULE_JSON   = "{ \"htmlValue\" : \"H\", \"optinValue\" : \"Y\", \"textValue\" : \"T\", \"insertOnNoMatch\" : true, \"updateOnMatch\" : \"REPLACE_ALL\", \"matchColumnName1\" : \"email_address_\", \"matchOperator\" : \"NONE\", \"optoutValue\" : \"N\", \"rejectRecordIfChannelEmpty\" : \"\", \"defaultPermissionStatus\" : \"OPTIN\" }"
      BATCH_SIZE        = "${var.batch_size}"
      BATCH_COUNT       = "${var.batch_count}"
      WAIT_TIME         = "${var.wait_time}"
      SCHEDULE_PERIOD   = "${var.update_scheduler_run_period}"
      FIFO_QUEUE_NAME   = "${var.queue_name}"
    }
  }

  tags = "${local.required_tags}"
}

resource "aws_cloudwatch_event_rule" "processSubscriberUpdateScheduler" {
  name = "${local.name_prefix}-processSubscriberUpdateScheduler-event-rule"
  description = "Fires every ${var.update_scheduler_run_period} minute(s)"
  schedule_expression = "rate(${var.update_scheduler_run_period} minute)"
}

resource "aws_cloudwatch_event_target" "processSubscriberUpdateScheduler" {
  rule      = "${aws_cloudwatch_event_rule.processSubscriberUpdateScheduler.name}"
  target_id = "${local.name_prefix}-processSubscriberUpdateScheduler-event-target"
  arn       = "${aws_lambda_function.processSubscriberUpdateScheduler.arn}"
}

resource "aws_lambda_permission" "processSubscriberUpdateScheduler" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.processSubscriberUpdateScheduler.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.processSubscriberUpdateScheduler.arn}"
}
