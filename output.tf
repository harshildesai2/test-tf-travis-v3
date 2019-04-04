output "API_URL" {
  value = "${module.api_gateway.API_URL}"
}

output "login_secretkey_data" {
  value = "${module.api_gateway.login_secretkey}"
}

output "login_accesskey_data" {
  value = "${module.api_gateway.login_accesskey}"
}