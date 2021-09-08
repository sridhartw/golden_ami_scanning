data "template_file" "approver_topic" {
  template = "${file("${abspath(path.module)}/policy_templates/approver_topic.json.tpl")}"
  vars = {
    automation_service_role = aws_iam_role.automation_service.arn
  }
}

module "approver_topic" {
  source = "./submodules/sns"
  resource-prefix = var.resource-prefix
  name = "approver"
  add_email_subscription = true
  sns_email_id = var.sns_email_id
  topic_policy_json = data.template_file.approver_topic.rendered
}