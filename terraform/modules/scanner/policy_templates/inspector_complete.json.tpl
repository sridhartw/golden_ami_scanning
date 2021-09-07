{
  "Id": "MyTopicPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "inspector-notifications-policy",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::485811472374:root"

        ]
      },
      "Action": "sns:Publish",
      "Resource": "*"
    }
  ]
}