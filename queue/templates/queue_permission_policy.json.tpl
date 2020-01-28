{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
		"Action": [
        	"SQS:SendMessage",
        	"SQS:GetQueueUrl"
      	],
      	"Effect": "Allow",
      	"Principal": "*"
    }
  ]
}
