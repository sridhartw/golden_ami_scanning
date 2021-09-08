
resource "aws_lambda_function" "this" {
  function_name = "${var.resource-prefix}-${var.name}"
  filename =  var.file_path
  source_code_hash = abspath(base64encode(var.file_path))
  handler = "index.lambda_handler"
  role = aws_iam_role.execution-role.arn
  runtime = "python3.6"
  timeout = 300
  memory_size = 512

  environment {
    variables = var.variables
  }

}

