{
  "Id": "ApproverTopicPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ApproverTopicPolicySID",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${automation_service_role}"
        ]
      },
      "Action": "sns:Publish",
      "Resource": "*"
    }
  ]
}