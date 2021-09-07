resource "aws_iam_role" "automation_service" {
  assume_role_policy = jsonencode({
    Version= "2012-10-17",
    Statement = [
      {
        Effect=  "Allow",
        Principal = {
          Service = [
            "ssm.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "template_file" "automation_service" {
  template = "${file("${path.module}/policy_templates/automation_service.json.tpl")}"
  vars = {
    managed_instance_iam_role = aws_iam_role.managed_instance.arn
    run_inspector_arn = module.run_inspector.lambda_arn
    append_ssm_param_arn = module.append_ssm_param.lambda_arn
    publish_ami_arn = module.publish_ami_lambda.lambda_arn
    run_inspector_arn = module.run_inspector.lambda_arn
    decommision_ami_version_arn = module.decommision_ami_version.lambda_arn
    initiate_assessment_arn = module.initiate_assessment.lambda_arn
  }
}

resource "aws_iam_policy" "automation_service" {
  name = "automation_service-policy"
  policy = data.template_file.automation_service.rendered
}

resource "aws_iam_role_policy_attachment" "automation_service_attachment1" {
  policy_arn = aws_iam_policy.automation_service.arn
  role = aws_iam_role.automation_service.name
}

resource "aws_iam_role_policy_attachment" "automation_service_attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
  role = aws_iam_role.automation_service.name
}

resource "aws_iam_instance_profile" "automation_service" {
  name = "automation_service_profile"
  role = aws_iam_role.automation_service.name
}