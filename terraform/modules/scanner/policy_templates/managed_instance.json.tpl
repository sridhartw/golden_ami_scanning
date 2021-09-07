{
  "Version": "2012-10-17",
  "Statement": {
    "Action": [
      "s3:*"
    ],
    "Effect": "Allow",
    "Resource": [
      "${ami_config_bucket}/*",
      "${ami_config_bucket}"
    ]
  }
}