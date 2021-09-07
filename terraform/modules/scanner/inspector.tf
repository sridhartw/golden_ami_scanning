resource "aws_inspector_resource_group" "this" {
  tags = {
    Name = "continuous-assessment-instance"
    Env  = "True"
  }
}

resource "aws_inspector_assessment_target" "this" {
  name               = "continuous assessment target"
  resource_group_arn = aws_inspector_resource_group.this.arn
}
