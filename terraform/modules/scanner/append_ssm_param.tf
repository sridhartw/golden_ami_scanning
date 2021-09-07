data "template_file" "append_ssm_param" {
  template = "${file("${path.module}/policy_templates/append_ssm_param.json.tpl")}"
  vars = {
    golden_ami_parameter = local.golden_ami_parameter
  }
}

data "archive_file" "append_ssm_param" {
  source_file = "${path.module}/source_code/append_ssm_param.py"
  output_path = "${path.root}/target/lambda/append_ssm_param.zip"
  type = "zip"
}

module "append_ssm_param" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "append_ssm_param"
  file_path = data.archive_file.append_ssm_param.output_path
  policy_json = data.template_file.append_ssm_param.rendered
}