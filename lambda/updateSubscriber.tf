locals {
  updateSubscriber_function_name = "updateSubscriber-${var.env_name}"
}

#log Group
resource "aws_cloudwatch_log_group" "updateSubscriber" {
  name = "/aws/lambda/${local.updateSubscriber_function_name}"
  retention_in_days = 14

  tags = "${local.required_tags}"
}

#role for lambda execution
resource "aws_iam_role" "updateSubscriber" {
  name = "updateSubscriber-role-${var.env_name}"
  assume_role_policy = "${file("${path.module}/templates/assume_role_policy.json.tpl")}"
}

#Parsing policy file
data "template_file" "updateSubscriber_policy" {
  template = "${file("${path.module}/templates/get_consentmgt_policy.json.tpl")}"

  vars {
    log_group  = "${aws_cloudwatch_log_group.updateSubscriber.name}"
  }
}

#building policy document
resource "aws_iam_policy" "updateSubscriber" {
  name = "updateSubscriber-policy-${var.env_name}"
  path = "/"
  description = "IAM policy for ${local.updateSubscriber_function_name} lambda function"
  policy = "${data.template_file.updateSubscriber_policy.rendered}"
}

#Attaching policy to role
resource "aws_iam_role_policy_attachment" "updateSubscriber" {
  role = "${aws_iam_role.updateSubscriber.name}"
  policy_arn = "${aws_iam_policy.updateSubscriber.arn}"
}

#Lambda function description
resource "aws_lambda_function" "updateSubscriber" {
  function_name = "${local.updateSubscriber_function_name}"

  s3_bucket = "${var.code_bucket}"
  s3_key    = "${var.jar_path}"

  handler = "com.amazonaws.lambda.responsys.UpdateSubscriberInfoHandler::handleRequest"
  role    = "${aws_iam_role.updateSubscriber.arn}"

  runtime     = "java8"
  memory_size = "512"
  timeout     = "15"

  environment {
    variables = {
      AUTH_TYPE = "password"
      PASSWORD  = ""
      RESPONSYS_AUTH_TOKEN_ENDPOINT = ""
      USERNAME  = "loyalty_API"
      UPDATE_API_URL  = "/rest/api/v1/lists/CONTACTS_LIST/members"
      MERGE_RULE_JSON = "{ \"htmlValue\" : \"H\", \"optinValue\" : \"Y\", \"textValue\" : \"T\", \"insertOnNoMatch\" : true, \"updateOnMatch\" : \"REPLACE_ALL\", \"matchColumnName1\" : \"email_address_\", \"matchOperator\" : \"NONE\", \"optoutValue\" : \"N\", \"rejectRecordIfChannelEmpty\" : \"\", \"defaultPermissionStatus\" : \"OPTIN\" }"
    }
  }

  tags = "${local.required_tags}"
}
