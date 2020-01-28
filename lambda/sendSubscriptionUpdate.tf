locals {  
  sendSubscriptionUpdate_function_name = "sendSubscriptionUpdate-${var.env_name}" 
} 

#log Group 
resource "aws_cloudwatch_log_group" "sendSubscriptionUpdate" {  
  name = "/aws/lambda/${local.sendSubscriptionUpdate_function_name}"  
  retention_in_days = "${var.logs_retention_in_days}" 

   tags = "${local.required_tags}"  
} 

resource "aws_cloudwatch_log_subscription_filter" "sendSubscriptionUpdate" { 
  count           = "${var.kinesis_firehose_delivery_stream_name == "" ? 0 : 1}"  
  name            = "${local.name_prefix}-sendSubscriptionUpdate-logfilter" 
  role_arn        = "${aws_iam_role.log_subscription.arn}"  
  log_group_name  = "${aws_cloudwatch_log_group.sendSubscriptionUpdate.name}" 
  destination_arn = "${local.kinesis_firehose_delivery_stream_arn}" 
  distribution    = "ByLogStream" 
  filter_pattern  = ""  
} 

#role for lambda execution 
resource "aws_iam_role" "sendSubscriptionUpdate" {  
  name = "sendSubscriptionUpdate-role-${var.env_name}"  
  assume_role_policy = "${file("${path.module}/templates/assume_role_policy.json.tpl")}"  
}

#Parsing policy file 
data "template_file" "sendSubscriptionUpdate_policy" {  
  template = "${file("${path.module}/templates/get_queue_write_policy.json.tpl")}"

   vars { 
    log_group             = "${aws_cloudwatch_log_group.sendSubscriptionUpdate.name}"  
    subscriber_queue_arn  = "${var.subscriber_queue_arn}"
  } 
} 

#building policy document  
resource "aws_iam_policy" "sendSubscriptionUpdate" {  
  name = "sendSubscriptionUpdate-policy-${var.env_name}"  
  path = "/"  
  description = "IAM policy for ${local.sendSubscriptionUpdate_function_name} lambda function"  
  policy = "${data.template_file.sendSubscriptionUpdate_policy.rendered}" 
} 

#Attaching policy to role  
resource "aws_iam_role_policy_attachment" "sendSubscriptionUpdate" {  
  role = "${aws_iam_role.sendSubscriptionUpdate.name}"  
  policy_arn = "${aws_iam_policy.sendSubscriptionUpdate.arn}" 
} 

#Lambda function description 
resource "aws_lambda_function" "sendSubscriptionUpdate" { 
  function_name = "${local.sendSubscriptionUpdate_function_name}" 

  s3_bucket         = "${data.aws_s3_bucket_object.lambda.bucket}"
  s3_key            = "${data.aws_s3_bucket_object.lambda.key}"
  s3_object_version = "${data.aws_s3_bucket_object.lambda.version_id}"

  handler = "com.amazonaws.lambda.responsys.SendSubscriptionUpdate::handleRequest"  
  role    = "${aws_iam_role.sendSubscriptionUpdate.arn}"  

  runtime     = "java8"  
  memory_size = "512" 
  timeout     = "15"  

  environment {  
    variables = { 
      QUEUE_MSG_ID      = "${var.queue_msg_id}"
      FIFO_QUEUE_NAME   = "${var.queue_name}"
    } 
  } 

  tags = "${local.required_tags}"  
}
