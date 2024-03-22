resource "aws_api_gateway_rest_api" "AventusAPI" {
  name        = "AventusAPI"
  description = "Demo API for generating random data"
}

resource "aws_api_gateway_resource" "AventusResource" {
  rest_api_id = aws_api_gateway_rest_api.AventusAPI.id
  parent_id   = aws_api_gateway_rest_api.AventusAPI.root_resource_id
  path_part   = "generate-data"
}

resource "aws_api_gateway_method" "AventusMethod" {
  rest_api_id   = aws_api_gateway_rest_api.AventusAPI.id
  resource_id   = aws_api_gateway_resource.AventusResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "LambdaIntegration" {
  rest_api_id = aws_api_gateway_rest_api.AventusAPI.id
  resource_id = aws_api_gateway_resource.AventusResource.id
  http_method = aws_api_gateway_method.AventusMethod.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}
