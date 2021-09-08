data "template_file" "run_inspector" {
  template = "${file("${abspath(path.module)}/policy_templates/run_inspector.json.tpl")}"
  vars = {
    golden_ami_parameter = local.golden_ami_parameter
  }
}

data "archive_file" "run_inspector" {
  source_file = "${abspath(path.module)}/source_code/run_inspector.py"
  output_path = "${abspath(path.root)}/target/lambda/run_inspector.zip"
  type = "zip"
}

module "run_inspector" {
  source = "./submodules/lambda"
  resource-prefix = var.resource-prefix
  name = "run_inspector"
  file_path = data.archive_file.run_inspector.output_path
  policy_json = data.template_file.run_inspector.rendered
  additional_policy_arn = ["arn:aws:iam::aws:policy/AmazonInspectorFullAccess"]
}