output "webkey_value" {
  value = "${aws_api_gateway_api_key.webkey.value}"
}

output "abteamkey_value" {
  value = "${aws_api_gateway_api_key.abteamkey.value}"
}

output "cneteamkey_value" {
  value = "${aws_api_gateway_api_key.cneteamkey.value}"
}
