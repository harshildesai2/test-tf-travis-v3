{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "execute-api:Invoke,InvalidateCache"
            ],
            "Resource": "arn:aws:execute-api:*:*:*/login"
        }
    ]
}