{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "execute-api:InvalidateCache",
                "execute-api:Invoke"
            ],
            "Resource": "arn:aws:execute-api:*:*:*/login"
        }
    ]
}