{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
            "logs:CreateLogGroup"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
    },
    {
        "Action": [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:log-group:${log_group}:*",
        "Effect": "Allow"
    },
    {
        "Action": [
            "sqs:SendMessage",
            "SQS:GetQueueUrl"
        ],
        "Resource": "${subscriber_queue_arn}",
        "Effect": "Allow"
    }
  ]
}
