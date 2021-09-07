
resource "aws_s3_bucket" "this" {
  bucket = "${var.resource_prefix}-${var.name}"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}