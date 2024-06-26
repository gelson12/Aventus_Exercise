resource "aws_s3_bucket_policy" "b_policy" {
  bucket = "aventus-bucket-in-account-b"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::123456789012:role/lambda_execution_role", # Replace 123456789012 with your actual AWS Account ID where the Lambda function resides.
      },
      Action = "s3:PutObject",
      Resource = "arn:aws:s3:::aventus-bucket-in-account-b/*",
    }],
  })
}
