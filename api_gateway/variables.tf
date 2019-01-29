variable "env_name" {
  description = "Environment name [dev, qa14,qa16, stage, prod]"
}

variable "env_region" {
  description = "aws_region"
}

variable "getSubscriber_invoke_arn" {
  description = "aws_lambda_function.getSubscriber.invoke_"
}

variable "getSubscriptionStatus_invoke_arn" {
  description = "aws_lambda_function.getSubscriptionStatus.invoke_"
}

variable "updateSubscriber_invoke_arn" {
  description = "aws_lambda_function.updateSubscriber.invoke_"
}

variable "getSubscriber_arn" {
  description = "aws_lambda_function.getSubscriber."
}

variable "getSubscriptionStatus_arn" {
  description = "aws_lambda_function.getSubscriptionStatus."
}

variable "updateSubscriber_arn" {
  description = "aws_lambda_function.updateSubscriber."
}

variable "required_tags" {
  type = "map"
  description = "Tags to apply to all resources"
}

locals {
  required_tags = "${var.required_tags}"
}
