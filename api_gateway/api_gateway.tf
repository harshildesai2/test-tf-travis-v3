
#Parsing swagger file
data "template_file" "swagger_template" {
  template = "${file("${path.module}/templates/swagger.json.tpl")}"

  vars {
    env_name                          = "${var.env_name}"
    region                            = "${data.aws_region.current.name}"
    login_invoke_arn                  = "${var.login_invoke_arn}"
    getSubscriber_invoke_arn          = "${var.getSubscriber_invoke_arn}"
    getSubscriptionStatus_invoke_arn  = "${var.getSubscriptionStatus_invoke_arn}"
    sendSubscriptionUpdate_invoke_arn = "${var.sendSubscriptionUpdate_invoke_arn}"
    apiexecution_user_arn             = "${aws_iam_user.api_execution.arn}"
    apiexecution_user_arn_login       = "${aws_iam_user.api_execution_login.arn}"
    fifo_queue_path                   = "arn:aws:apigateway:${data.aws_region.current.name}:sqs:path/${data.aws_caller_identity.current.account_id}/${var.queue_name}"
  }
}

data "aws_iam_policy_document" "consent_mgt_rest_api" {
  statement {
    actions   = ["execute-api:Invoke"]
    resources = [
      "arn:aws:execute-api:${data.aws_region.current.name}:*:*/*/POST/getsubscriberinfo",
      "arn:aws:execute-api:${data.aws_region.current.name}:*:*/*/POST/getsubscriptionstatus"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_user.api_execution.arn}"
      ]
    }
  }
  statement {
    actions   = ["execute-api:*"]
    resources = [
      "arn:aws:execute-api:${data.aws_region.current.name}:*:*/*/POST/login"
    ]
    principals {
        type = "AWS"
        identifiers = ["${aws_iam_user.api_execution_login.arn}"]
    }
  }
  statement {
    actions   = ["execute-api:Invoke"]
    principals {
        type = "AWS"
        identifiers = ["*"]
    }
    resources = [
      "arn:aws:execute-api:${data.aws_region.current.name}:*:*/*/OPTIONS/getsubscriberinfo",
      "arn:aws:execute-api:${data.aws_region.current.name}:*:*/*/OPTIONS/getsubscriptionstatus",
      "arn:aws:execute-api:${data.aws_region.current.name}:*:*/*/OPTIONS/sendsubscriberupdate",
      "arn:aws:execute-api:${data.aws_region.current.name}:*:*/*/POST/sendsubscriberupdate"
    ]
  }
}

#Creating apigateway
resource "aws_api_gateway_rest_api" "consent_mgt" {
  name = "consent-management-${var.env_name}"
  description = "Consent management responsys API"
  body   = "${data.template_file.swagger_template.rendered}"
  policy = "${data.aws_iam_policy_document.consent_mgt_rest_api.json}"
}

#API deployment
resource "aws_api_gateway_deployment" "consent_mgt" {
  depends_on = [
    "aws_api_gateway_rest_api.consent_mgt"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.consent_mgt.id}"
  stage_name  = "stage"
  stage_description = "MD5 hash of Swagger template: ${md5(file("${path.module}/templates/swagger.json.tpl"))}"
}

# Promote deployment to 'v1' stage
resource "aws_api_gateway_stage" "v1" {
  stage_name    = "v1"
  description   = "MD5 hash of Swagger template: ${md5(file("${path.module}/templates/swagger.json.tpl"))}"
  rest_api_id   = "${aws_api_gateway_rest_api.consent_mgt.id}"
  deployment_id = "${aws_api_gateway_deployment.consent_mgt.id}"

  access_log_settings {
    destination_arn = "${aws_cloudwatch_log_group.apigw_access_logs.arn}"
    format          = "$$context.identity.sourceIp $$context.identity.caller $$context.identity.user [$$context.requestTime] \"$$context.httpMethod $$context.resourcePath $$context.protocol\" $$context.status $$context.responseLength $$context.requestId"
  }

  tags = "${local.required_tags}"
  cache_cluster_enabled = true
  cache_cluster_size = "0.5"
}


# method setting for LOGIN api-gateway resources
resource "aws_api_gateway_method_settings" "login" {
  rest_api_id = "${aws_api_gateway_rest_api.consent_mgt.id}"
  stage_name  = "${aws_api_gateway_stage.v1.stage_name}"
  method_path = "login/POST"

  settings {
    require_authorization_for_cache_control = true
    unauthorized_cache_control_header_strategy = "SUCCEED_WITHOUT_RESPONSE_HEADER"
    metrics_enabled = true
    logging_level   = "INFO"
    caching_enabled = true
    cache_ttl_in_seconds  = 3600
  }
}

#permission for login apigateway
resource "aws_lambda_permission" "apig_login" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.login_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.consent_mgt.execution_arn}/*/*"
}

#permission for getSubscriber apigateway resource
resource "aws_lambda_permission" "apig_getSubscriber" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.getSubscriber_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.consent_mgt.execution_arn}/*/*"
}

#permission for getSubscriptionStatus apigateway resource
resource "aws_lambda_permission" "apig_getSubscriptionStatus" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.getSubscriptionStatus_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.consent_mgt.execution_arn}/*/*"
}

#permission for sendSubscriptionUpdate apigateway resource
resource "aws_lambda_permission" "apig_sendSubscriptionUpdate" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.sendSubscriptionUpdate_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.consent_mgt.execution_arn}/*/*"
}

#iam user for executing the api 
resource "aws_iam_user" "api_execution" {
  name = "${local.name_prefix}-apigw-user"
  path = "/${local.name_prefix}/"
}

#Parsing policy file
data "template_file" "apiuser_policy" {
  template = "${file("${path.module}/templates/execute_api_policy.json.tpl")}"
}

#building policy document
resource "aws_iam_policy" "api_execution" {
  name = "${local.name_prefix}-apiexecution-policy"
  description = "IAM policy for executing Consent Management API"
  path = "/${local.name_prefix}/"
  policy = "${data.template_file.apiuser_policy.rendered}"
}

#attaching policy to the user
resource "aws_iam_user_policy_attachment" "api_execution" {
  user = "${aws_iam_user.api_execution.name}"
  policy_arn = "${aws_iam_policy.api_execution.arn}"
}

#iam user for executing the api for login API 
resource "aws_iam_user" "api_execution_login" {
  name = "${local.name_prefix}-apigw-login-user"
  path = "/${local.name_prefix}/"
}

#Parsing policy file for Login API
data "template_file" "apiuser_policy_login" {
  template = "${file("${path.module}/templates/execute_api_policy_login.json.tpl")}"
}

#building policy document for Login API
resource "aws_iam_policy" "api_execution_login" {
  name = "${local.name_prefix}-apiexecution-login-policy"
  description = "IAM policy for executing Consent Management API for Login resource"
  path = "/${local.name_prefix}/"
  policy = "${data.template_file.apiuser_policy_login.rendered}"
}

#attaching policy to the Login API user
resource "aws_iam_user_policy_attachment" "api_execution_login" {
  user = "${aws_iam_user.api_execution_login.name}"
  policy_arn = "${aws_iam_policy.api_execution_login.arn}"
}

#Generating keys for the Login resource
resource "aws_iam_access_key" "key_login" {
  user    = "${aws_iam_user.api_execution_login.name}"
}