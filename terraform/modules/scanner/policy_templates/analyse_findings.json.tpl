{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AnalyzeInspectorFindingsLambdaPolicyStmt",
      "Effect": "Allow",
      "Action": [
        "inspector:AddAttributesToFindings",
        "inspector:DescribeFindings",
        "ec2:DescribeInstances",
        "inspector:ListFindings"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Sid": "AnalyzeInspectorFindingsLambdaPolicyStmt2",
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": ["${continuous_result_topic}"]
    },
    {
      "Sid": "AnalyzeInspectorFindingsLambdaPolicyStmt3",
      "Effect": "Allow",
      "Action": [
        "ec2:TerminateInstances"
      ],
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/continuous-assessment-instance": "true"
        }
      }
    }
  ]
}