resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.path
  max_session_duration = var.max_session_duration
  assume_role_policy   = var.assume_role_policy
  managed_policy_arns  = var.managed_policy_arns

  inline_policy {
    name   = var.inline_policy_cloudwatch_name
    policy = var.inline_policy_cloudwatch_document
  }

  inline_policy {
    name   = var.inline_policy_start_execution_name
    policy = var.inline_policy_start_execution_document
  }

  inline_policy {
    name   = var.inline_policy_invoke_lambda_name
    policy = var.inline_policy_invoke_lambda_document
  }

  inline_policy {
    name   = var.inline_policy_read_data_name
    policy = var.inline_policy_read_data_document
  }

  inline_policy {
    name   = var.inline_policy_sqs_send_name
    policy = var.inline_policy_sqs_send_document
  }

  inline_policy {
    name   = var.inline_policy_write_results_name
    policy = var.inline_policy_write_results_document
  }
}