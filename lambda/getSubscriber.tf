locals {
  getSubscriber_function_name = "getSubscriber-${var.env_name}"
}

#log Group
resource "aws_cloudwatch_log_group" "getSubscriber" {
  name = "/aws/lambda/${local.getSubscriber_function_name}"
  retention_in_days = 14

  tags = "${local.required_tags}"
}

#role for lambda execution
resource "aws_iam_role" "getSubscriber" {
  name = "getSubscriber-role-${var.env_name}"
  assume_role_policy = "${file("${path.module}/templates/assume_role_policy.json.tpl")}"
}

#Parsing policy file
data "template_file" "getSubscriber_policy" {
  template = "${file("${path.module}/templates/get_consentmgt_policy.json.tpl")}"

  vars {
    log_group  = "${aws_cloudwatch_log_group.getSubscriber.name}"
  }
}

#building policy document
resource "aws_iam_policy" "getSubscriber" {
  name = "getSubscriber-policy-${var.env_name}"
  path = "/"
  description = "IAM policy for ${local.getSubscriber_function_name} lambda function"
  policy = "${data.template_file.getSubscriber_policy.rendered}"
}

#Attaching policy to role
resource "aws_iam_role_policy_attachment" "getSubscriber" {
  role = "${aws_iam_role.getSubscriber.name}"
  policy_arn = "${aws_iam_policy.getSubscriber.arn}"
}

#Lambda function description
resource "aws_lambda_function" "getSubscriber" {
  function_name = "${local.getSubscriber_function_name}"

  s3_bucket = "${var.code_bucket}"
  s3_key    = "${var.jar_path}"

  handler = "com.amazonaws.lambda.responsys.GetSubscriberInfoHandler::handleRequest"
  role    = "${aws_iam_role.getSubscriber.arn}"

  runtime     = "java8"
  memory_size = "512"
  timeout     = "15"

  environment {
    variables = {
      AUTH_TYPE = "password"
      PASSWORD = "${var.api_password}"
      RESPONSYS_AUTH_TOKEN_ENDPOINT = "${var.api_endpoint}"
      USERNAME = "loyalty_API"
      GET_MEMBER_API_URL  = "/rest/api/v1/lists/CONTACTS_LIST/members/"
      GET_FIELD_PARAMS = "EMAIL_ADDRESS_,COUNTRY_,PRODUCT_GENDER,PRODUCT_ACTIVITIES,RIID_,EMAIL_PERMISSION_STATUS_"
      IS_TRANSFORM_RESPONSE = "false"
    }
  }

  tags = "${local.required_tags}"
}
