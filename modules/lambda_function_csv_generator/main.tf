resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  architectures = var.architectures
  package_type  = var.package_type
  tags          = var.tags

  environment {
    variables = var.environment_variables
  }

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  tracing_config {
    mode = var.tracing_mode
  }
}