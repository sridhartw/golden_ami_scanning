data "template_file" "analyse_findings" {
  template = "${file("${abspath(path.module)}/policy_templates/analyse_findings.json.tpl")}"
  vars = {
    continuous_result_topic = aws_sns_topic.assessment_result.arn
  }
}

data "template_file" "assessment_complete" {
  template = "${file("${abspath(path.module)}/policy_templates/assessment_complete.json.tpl")}"
}

data "archive_file" "analyse_findings" {
  source_file = "${abspath(path.module)}/source_code/analyse_findings.py"
  output_path = "${abspath(path.root)}/target/lambda/analyse_findings.zip"
  type = "zip"
}

module "analyse_findings" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "analyse_findings"
  file_path = data.archive_file.analyse_findings.output_path
  policy_json = data.template_file.analyse_findings.rendered
  variables = {
    continuous_result_topic = aws_sns_topic.assessment_result.arn
  }
}

module "assessment_result_complete" {
  source = "./submodules/sns"
  resource-prefix = var.resource-prefix
  topic_policy_json = data.template_file.assessment_complete.rendered
  name = "assessment_result_complete"
  add_lambda_subscription = true
  lambda_arn = module.analyse_findings.lambda_arn
}

resource "aws_sns_topic" "assessment_result" {
  name = "${var.resource-prefix}-assessment_result"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.assessment_result.arn
  protocol  = "email"
  endpoint  = var.sns_email_id
}

resource "aws_lambda_permission" "allow_sns2" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.analyse_findings.lambda_name
  principal     = "sns.amazonaws.com"
  source_arn    = module.assessment_result_complete.sns_topic_arn
}