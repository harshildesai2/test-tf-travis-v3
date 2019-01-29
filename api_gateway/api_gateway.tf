#Parsing swagger file
data "template_file" "swagger_template" {
  template = "${file("${path.module}/templates/swagger.json.tpl")}"

  vars {
    env_name = "${var.env_name}"
    region   = "${var.env_region}"
    getSubscriber_invoke_arn = "${var.getSubscriber_invoke_arn}"
    getSubscriptionStatus_invoke_arn = "${var.getSubscriptionStatus_invoke_arn}"
    updateSubscriber_invoke_arn = "${var.updateSubscriber_invoke_arn}"
    apiexecution_user_arn = "${aws_iam_user.api-execution-user.arn}"
  }
}

#Creating apigateway
resource "aws_api_gateway_rest_api" "consent_mgt" {
  name = "consent-management-${var.env_name}"
  description = "Consent management responsys API"
  body = "${data.template_file.swagger_template.rendered}"
}

#API deployment
resource "aws_api_gateway_deployment" "consent_mgt" {
  depends_on = [
    "aws_api_gateway_rest_api.consent_mgt"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.consent_mgt.id}"
  stage_name  = "v1"
  stage_description = "${md5(file("${path.module}/templates/swagger.json.tpl"))}"
}

#permission for getSubscriber apigateway
resource "aws_lambda_permission" "apig_getSubscriber" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.getSubscriber_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.consent_mgt.execution_arn}/*/*"
}

#permission for getSubscriptionStatus apigateway
resource "aws_lambda_permission" "apig_getSubscriptionStatus" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.getSubscriptionStatus_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.consent_mgt.execution_arn}/*/*"
}

#permission for updateSubscriber
resource "aws_lambda_permission" "apig_updateSubscriber" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.updateSubscriber_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.consent_mgt.execution_arn}/*/*"
}

#iam user for executing the api
resource "aws_iam_user" "api-execution-user" {
  name = "consentmgt-apiexecution-user-${var.env_name}"
  path = "/system/" 
}

#Parsing policy file
data "template_file" "apiuser_policy" {
  template = "${file("${path.module}/templates/execute_api_policy.json.tpl")}"
}

#building policy document
resource "aws_iam_policy" "api-execution-policy" {
  name = "consentmgt-apiexecution-policy-${var.env_name}"
  description = "IAM policy for executing api"
  path = "/"
  policy = "${data.template_file.apiuser_policy.rendered}"
}

#attaching policy to the user
resource "aws_iam_user_policy_attachment" "attach-api-execution-policy" {
  user = "${aws_iam_user.api-execution-user.name}"
  policy_arn = "${aws_iam_policy.api-execution-policy.arn}"
}