data "template_file" "publish_ami_policy_json" {
  template = "${file("${abspath(path.module)}/policy_templates/publish_ami_policy.json.tpl")}"
  vars = {
    golden_ami_parameter = local.golden_ami_parameter
    ami_config_bucket = var.ami_config_bucket
  }
}

data "archive_file" "publish_ami_lambda_artifact" {
  source_file = "${abspath(path.module)}/source_code/publish_ami.py"
  output_path = "${abspath(path.root)}/target/lambda/publish_ami.zip"
  type = "zip"
}

module "publish_ami_lambda" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "publish_lambda"
  file_path = data.archive_file.publish_ami_lambda_artifact.output_path
  policy_json = data.template_file.publish_ami_policy_json.rendered
}