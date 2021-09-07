resource "aws_iam_role" "execution-role" {
  name = "${var.resource-prefix}-${var.name}-lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name = "${var.resource-prefix}-${var.name}-lambda-additional-permission"
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.execution-role.name
}

resource "aws_iam_role_policy_attachment" "policy" {
  policy_arn = aws_iam_policy.policy.arn
  role = aws_iam_role.execution-role.name
}

resource "aws_iam_role_policy_attachment" "additional_policy" {
  count = length(var.additional_policy_arn)
  policy_arn = var.additional_policy_arn[count.index]
  role = aws_iam_role.execution-role.name
}