{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter*",
        "ssm:PutParameter*"
      ],
      "Resource": [
        "${golden_ami_parameter}"
      ]
    }
  ]
}

