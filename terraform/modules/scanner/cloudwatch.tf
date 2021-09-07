resource "aws_cloudwatch_event_rule" "schedule" {
  schedule_expression = var.inspection_frequency
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "this" {
  arn = module.setup_continuous_assessment.lambda_arn
  rule = aws_cloudwatch_event_rule.schedule.name
  target_id = "TargetFunctionV1"
  input =  "{\"AMIsParamName\":\"/GoldenAMI/latest\", \"instanceType\":\"${var.instance_type}\"}"
}