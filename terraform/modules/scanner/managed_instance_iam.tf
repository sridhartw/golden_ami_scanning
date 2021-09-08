resource "aws_iam_role" "managed_instance" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "ssm.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "template_file" "managed_instance" {
  template = "${file("${abspath(path.module)}/policy_templates/managed_instance.json.tpl")}"
  vars = {
    ami_config_bucket = var.ami_config_bucket
  }
}

resource "aws_iam_policy" "managed_instance" {
  name = "managed_instance-policy"
  policy = data.template_file.managed_instance.rendered
}

resource "aws_iam_role_policy_attachment" "managed_instance_attachment1" {
  policy_arn = aws_iam_policy.managed_instance.arn
  role = aws_iam_role.managed_instance.name
}

resource "aws_iam_role_policy_attachment" "managed_instance_attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role = aws_iam_role.managed_instance.name
}

resource "aws_iam_instance_profile" "managed_instance" {
  name = "managed_instance_profile"
  role = aws_iam_role.managed_instance.name
}