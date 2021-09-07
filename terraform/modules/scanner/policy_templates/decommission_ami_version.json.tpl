{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter*",
        "ssm:PutParameter*",
        "ssm:delete*"
      ],
      "Resource": [
        "${golden_ami_parameter}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:delete*",
        "s3:get*"
      ],
      "Resource": [
        "${ami_config_bucket}/*",
        "${ami_config_bucket}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeregisterImage",
        "ec2:DescribeSnapshots",
        "ec2:DeleteSnapshot",
        "sc:list*",
        "sc:search*",
        "servicecatalog:SearchProductsAsAdmin",
        "servicecatalog:ListProvisioningArtifacts",
        "servicecatalog:DeleteProduct",
        "servicecatalog:DeleteProvisioningArtifact"
      ],
      "Resource": "*"
    }
  ]
}