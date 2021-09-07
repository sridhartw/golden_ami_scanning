data "template_file" "setup_continuous_assessment" {
  template = "${file("${path.module}/policy_templates/setup_continuous_assessment.json.tpl")}"
  vars = {
    golden_ami_parameter = local.golden_ami_parameter
    managed_instance_iam_role = aws_iam_role.managed_instance.arn
    account = data.aws_caller_identity.this.account_id
    region = data.aws_region.this.name
  }
  depends_on = []
}

data "archive_file" "setup_continuous_assessment" {
  source_file = "${path.module}/source_code/setup_continuous_assessment.py"
  output_path = "${path.root}/target/lambda/setup_continuous_assessment.zip"
  type = "zip"
}
module "setup_continuous_assessment" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "setup_continuous_assessment"
  file_path = data.archive_file.setup_continuous_assessment.output_path
  policy_json = data.template_file.setup_continuous_assessment.rendered
  additional_policy_arn = ["arn:aws:iam::aws:policy/AmazonInspectorFullAccess"]
  variables = {
    managed_instance_iam_role = aws_iam_role.managed_instance.arn
    security_group_id = var.security_group_id
    subnet_id = var.subnet_id
    continuous_assessment_target = aws_inspector_assessment_target.this.arn
    continuous_assessment_complete_topic = module.assessment_result_complete.sns_topic_arn
    run_continuous_inspection = aws_ssm_document.run_continuous_inspection.name
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudwatch"
  action        = "lambda:InvokeFunction"
  function_name = module.setup_continuous_assessment.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}