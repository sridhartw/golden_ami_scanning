data "template_file" "assess_assessment" {
  template = "${file("${path.module}/policy_templates/assess_assessment.json.tpl")}"
  vars = {
    golden_ami_parameter = local.golden_ami_parameter
  }
}

data "template_file" "inspector_complete" {
  template = "${file("${path.module}/policy_templates/inspector_complete.json.tpl")}"
}

data "archive_file" "assess_assessment" {
  source_file = "${path.module}/source_code/assess_assessment.py"
  output_path = "${path.root}/target/lambda/assess_assessment.zip"
  type = "zip"
}

module "assess_assessment" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "assess_assessment"
  file_path = data.archive_file.assess_assessment.output_path
  policy_json = data.template_file.assess_assessment.rendered
}

module "inspector_complete" {
  source = "./submodules/sns"
  resource-prefix = var.resource-prefix
  name = "approver"
  topic_policy_json = data.template_file.inspector_complete.rendered
  add_lambda_subscription = true
  lambda_arn = module.assess_assessment.lambda_arn
}

resource "aws_lambda_permission" "allow_sns1" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.assess_assessment.lambda_name
  principal     = "sns.amazonaws.com"
  source_arn    = module.approver_topic.sns_topic_arn
}