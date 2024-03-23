provider "aws" {
  region                      = var.aws_region
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = var.aws_endpoint_url
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_endpoint_url" {
  description = "Endpoint URL for AWS services"
  type        = string
  default     = "http://localhost:4566" # Default to LocalStack for local development
}
/*For real AWS deployments, ensure var.aws_endpoint_url is unset or set to null, and use actual AWS credentials instead of mock values. */








/*provider "aws" {
  region = "us-east-1"
}*/

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
  source_code_hash = filebase64sha256("lambda_function_payload.zip")#may need to automate script zipping
  runtime          = "python3.8"
}
