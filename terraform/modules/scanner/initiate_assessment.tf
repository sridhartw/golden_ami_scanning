data "template_file" "initiate_assessment" {
  template = "${file("${abspath(path.module)}/policy_templates/initiate_assessment.json.tpl")}"
  vars = {
    golden_ami_parameter = local.golden_ami_parameter
    account = data.aws_caller_identity.this.account_id
    region = data.aws_region.this.name
  }
}

data "archive_file" "initiate_assessment" {
  source_file = "${abspath(path.module)}/source_code/initiate_assessment.py"
  output_path = "${abspath(path.root)}/target/lambda/initiate_assessment.zip"
  type = "zip"
}

module "initiate_assessment" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "initiate_assessment"
  file_path = data.archive_file.initiate_assessment.output_path
  policy_json = data.template_file.initiate_assessment.rendered
  additional_policy_arn = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
}