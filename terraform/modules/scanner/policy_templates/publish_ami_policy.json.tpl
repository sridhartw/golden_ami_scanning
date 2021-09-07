{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter*"
      ],
      "Resource": [
        "${golden_ami_parameter}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject*",
        "s3:PutObject*"
      ],
      "Resource": [
        "${ami_config_bucket}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "servicecatalog:SearchProductsAsAdmin",
        "servicecatalog:CreateProvisioningArtifact",
        "servicecatalog:CreateProduct",
        "cloudformation:ValidateTemplate"
      ],
      "Resource": "*"
    }
  ]
}
