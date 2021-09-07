{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "StartContinuousAssessmentLambdaPolicyStmt2",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeImages"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "${managed_instance_iam_role}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "ssm:StartAutomationExecution",
      "Resource": [
        "arn:aws:ssm:${region}:${account}:automation-definition/:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CopyImage",
        "ec2:DescribeImages"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:createTags"
      ],
      "Resource": "*",
      "Condition": {
        "ForAllValues:StringEquals": {
          "aws:TagKeys": [
            "AMI-Type",
            "ProductName",
            "continuous-assessment-instance",
            "ProductOSAndVersion",
            "version"
          ]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateIamInstanceProfile"
      ],
      "Resource": [
        "${managed_instance_iam_role}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "ec2:RunInstances",
      "Resource": [
        "arn:aws:ec2:${region}::image/ami-*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/AMI-Type": "Golden"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "ec2:RunInstances",
      "Resource": [
        "arn:aws:ec2:${region}:${account}:instance/*",
        "arn:aws:ec2:${region}:${account}:subnet/*",
        "arn:aws:ec2:${region}:${account}:volume/*",
        "arn:aws:ec2:${region}:${account}:network-interface/*",
        "arn:aws:ec2:${region}:${account}:key-pair/*",
        "arn:aws:ec2:${region}:${account}:security-group/*"
      ]
    }
  ]
}