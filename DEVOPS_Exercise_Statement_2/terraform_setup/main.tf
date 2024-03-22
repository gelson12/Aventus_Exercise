provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com",
      },
    }],
  })

  # Assuming the Lambda needs to write to an S3 bucket, add the necessary permissions.
  inline_policy {
    name = "write_to_s3"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Action = [
          "s3:PutObject",
        ],
        Effect = "Allow",
        Resource = "arn:aws:s3:::aventus-bucket-in-account-b/*",
      }],
    })
  }
}

resource "aws_lambda_function" "my_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "my_random_data_generator"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "generate_random_data.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime          = "python3.8"
}
