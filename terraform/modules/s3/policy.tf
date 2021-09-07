// TODO : IMPLEMENT THIS ----- CIRCULAR DEPENDENCY POSES A PROBLEM
//resource "aws_s3_bucket_policy" "b" {
//  bucket = aws_s3_bucket.this.id
//
//  policy = jsonencode({
//    Version = "2012-10-17"
//    Id      = "Default Bucket Policy"
//    Statement = [
//      {
//        Sid       = "IPAllow"
//        Effect    = "Allow"
//        Principal = var.allowed_role_arn_list
//        Action    = "s3:*"
//        Resource = [
//          aws_s3_bucket.this.arn,
//          "${aws_s3_bucket.this.arn}/*",
//        ]
//      }
//    ]
//  })
//}