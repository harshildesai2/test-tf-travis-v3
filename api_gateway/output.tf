output "API_URL" {
  value = "${aws_api_gateway_deployment.consent_mgt.invoke_url}"
}
