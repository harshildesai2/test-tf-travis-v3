output "getSubscriber_invoke_arn" {
  value = "${aws_lambda_function.getSubscriber.invoke_arn}"
}

output "getSubscriptionStatus_invoke_arn" {
  value = "${aws_lambda_function.getSubscriptionStatus.invoke_arn}"
}

output "updateSubscriber_invoke_arn" {
  value = "${aws_lambda_function.updateSubscriber.invoke_arn}"
}

output "getSubscriber_arn" {
  value = "${aws_lambda_function.getSubscriber.arn}"
}

output "getSubscriptionStatus_arn" {
  value = "${aws_lambda_function.getSubscriptionStatus.arn}"
}

output "updateSubscriber_arn" {
  value = "${aws_lambda_function.updateSubscriber.arn}"
}
