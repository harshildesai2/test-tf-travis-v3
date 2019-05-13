output "API_URL" {
  value = "${module.api_gateway.API_URL}"
}

output "webkey_value" {
  value = "${module.usage_plan.webkey_value}"
}

output "subscriber_queue_arn" {
  value = "${module.queue.subscriber_queue_arn}"
}

output "subscriber_queue_path" {
  value = "${module.queue.subscriber_queue_path}"
}
