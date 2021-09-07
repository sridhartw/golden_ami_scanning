{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ssm:PutParameter",
      "Resource": [
        "${golden_ami_parameter}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "inspector:DescribeAssessmentTemplates",
        "inspector:DescribeFindings",
        "inspector:ListFindings"
      ],
      "Resource": "*"
    }
  ]
}