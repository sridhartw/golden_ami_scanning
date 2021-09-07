{
  "Id": "MyTopicPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "My-statement-id",
      "Effect": "Allow",
      "Principal": {
        "Service": "inspector.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "*"
    }
  ]
}