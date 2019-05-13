variable "env_name" {
  description = "Environment name [dev, qa14, qa16, stage, prod]"
}

variable "required_tags" {
  type = "map"
  description = "Tags to apply to all resources"
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Default: 1209600"
  default     = "1209600"
}

variable "queue_visibility_timeout_seconds" {
  description = "The visibility timeout for the queue messages. Default: 10"
  default     = "10"
}

variable "msg_retry_count" {
  description = "Max no of times a message can be retried before it is sent to Dead Letter Queue. Default: 50"
  default     = "50"
}

variable "queue_name" {
  description = "Name of the FIFO queue for posting the subscription messages"
}

variable "dead_letter_queue_name" {
  description = "Name of the FIFO queue for posting the Dead subscription messages"
}

locals {
  required_tags  = "${var.required_tags}"
}
