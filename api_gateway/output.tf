output "API_URL" {
  value = "${aws_api_gateway_deployment.consent_mgt.invoke_url}"
}

output "login_secret_key" {
  value = "${aws_iam_access_key.key_login.secret}"
}

output "login_access_key" {
  value = "${aws_iam_access_key.key_login.id}"
}

output "api_resource_id" {
  value = "${aws_api_gateway_rest_api.consent_mgt.id}"
}

output "stage_name" {
  value = "${aws_api_gateway_stage.v1.stage_name}"
}