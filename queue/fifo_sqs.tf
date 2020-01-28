# Parsing policy file
data "template_file" "queue_policy" {
  template = "${file("${path.module}/templates/queue_permission_policy.json.tpl")}"
}

# Defining the FIFO dead queue
resource "aws_sqs_queue" "dead_letter" {
  name                          = "${var.dead_letter_queue_name}"
  fifo_queue                    = true
  content_based_deduplication   = false
  visibility_timeout_seconds    = "${var.queue_visibility_timeout_seconds}"
  message_retention_seconds     = "${var.message_retention_seconds}"
  tags                          = "${local.required_tags}"
}

# Defining the FIFO SQS queue
resource "aws_sqs_queue" "subscriber_queue" {
  name                          = "${var.queue_name}"
  fifo_queue                    = true
  content_based_deduplication   = true
  visibility_timeout_seconds    = "${var.queue_visibility_timeout_seconds}"
  message_retention_seconds     = "${var.message_retention_seconds}"
  policy                        = "${data.template_file.queue_policy.rendered}"
  redrive_policy                = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter.arn}\",\"maxReceiveCount\":${var.msg_retry_count}}"
  tags                          = "${local.required_tags}"
}
