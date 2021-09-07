data "template_file" "decommision_ami_version_doc" {
  template = "${file("${path.module}/documents/decommision_ami_version.json.tpl")}"
  vars = {
    automation_service_role = aws_iam_role.automation_service.arn
    ami_config_bucket = var.ami_config_bucket
    resource-prefix = var.resource-prefix
    default_ami = var.default_ami
    decommision_ami_version_lambda = module.decommision_ami_version.lambda_arn
  }
}

data "template_file" "golden_ami_automation" {
  template = "${file("${path.module}/documents/golden_ami_automation.json.tpl")}"
  vars = {
    automation_service_role = aws_iam_role.automation_service.arn
    resource-prefix = var.resource-prefix
    default_ami = var.default_ami
    approver_arn = var.approver_arn
    approver_topic_arn = module.approver_topic.sns_topic_arn
    subnet_id = var.subnet_id
    security_group = var.security_group_id
    instance_type = var.instance_type
    managed_instance_profile = aws_iam_instance_profile.managed_instance.arn
    run_inspector_arn = module.run_inspector.lambda_arn
    inspector_complete_topic = module.inspector_complete.sns_topic_arn
    append_ssm_param_arn = module.append_ssm_param.lambda_arn
  }
}

data "template_file" "run_continuous_inspection" {
  template = "${file("${path.module}/documents/run_continuous_inspection.json.tpl")}"
  vars = {
    automation_service_role = aws_iam_role.automation_service.arn
    initiate_assessment_lambda = module.initiate_assessment.lambda_arn
  }
}



resource "aws_ssm_document" "decommision_ami_version" {
  content = data.template_file.decommision_ami_version_doc.rendered
  document_type = "Automation"
  name = "decommision_ami_version"
}

resource "aws_ssm_document" "golden_ami_automation" {
  content = data.template_file.golden_ami_automation.rendered
  document_type = "Automation"
  name = "golden_ami_automation"
}

resource "aws_ssm_document" "run_continuous_inspection" {
  content = data.template_file.run_continuous_inspection.rendered
  document_type = "Automation"
  name = "run_continuous_inspection"
}


