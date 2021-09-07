resource "aws_sns_topic" "this" {
  name = "${var.resource-prefix}-${var.name}"
}

resource "aws_sns_topic_subscription" "email" {
  count = var.add_email_subscription ? 1 : 0
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.sns_email_id
}

resource "aws_sns_topic_subscription" "lambda" {
  count = var.add_lambda_subscription ? 1 : 0
  topic_arn = aws_sns_topic.this.arn
  protocol  = "lambda"
  endpoint  = var.lambda_arn
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.this.arn
  policy = var.topic_policy_json
}