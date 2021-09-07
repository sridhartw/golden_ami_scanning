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
    },
    {
      "Action": "ssm:SendCommand",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ssm:${region}::document/AmazonInspector-ManageAWSAgent",
        "arn:aws:ec2:${region}:${account}:instance/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "inspector:ListAssessmentTemplates",
        "inspector:StartAssessmentRun"
      ],
      "Resource": "*"
    }
  ]
}