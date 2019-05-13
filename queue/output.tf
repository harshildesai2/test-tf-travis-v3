output "subscriber_queue_arn" {
  value = "${aws_sqs_queue.subscriber_queue.arn}"
}

output "subscriber_queue_path" {
  value = "arn:aws:apigateway:${data.aws_region.current.name}:sqs:path/${data.aws_caller_identity.current.account_id}/${var.queue_name}"
}