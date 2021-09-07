data "template_file" "decommission_ami_version" {
  template = "${file("${path.module}/policy_templates/decommission_ami_version.json.tpl")}"
  vars = {
    golden_ami_parameter = local.golden_ami_parameter
    ami_config_bucket = var.ami_config_bucket
  }
}

data "archive_file" "decommission_ami_version" {
  source_file = "${path.module}/source_code/decommission_ami_version.py"
  output_path = "${path.root}/target/lambda/decommission_ami_version.zip"
  type = "zip"
}

module "decommision_ami_version" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "decommission_ami_version"
  file_path = data.archive_file.decommission_ami_version.output_path
  policy_json = data.template_file.decommission_ami_version.rendered
}