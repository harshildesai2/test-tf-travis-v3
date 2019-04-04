output "API_URL" {
  value = "${aws_api_gateway_deployment.consent_mgt.invoke_url}"
}

output "login_secretkey" {
  value = "${aws_iam_access_key.key_login.secret}"
}

output "login_accesskey" {
  value = "${aws_iam_access_key.key_login.id}"
}