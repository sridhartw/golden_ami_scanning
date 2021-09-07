{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": [
        "${managed_instance_iam_role}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": [
        "${run_inspector_arn}",
        "${append_ssm_param_arn}",
        "${publish_ami_arn}",
        "${run_inspector_arn}",
        "${decommision_ami_version_arn}",
        "${initiate_assessment_arn}"
      ]
    }
  ]
}
