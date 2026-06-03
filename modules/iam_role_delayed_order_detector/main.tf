resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.path
  max_session_duration = var.max_session_duration
  assume_role_policy   = var.assume_role_policy
  managed_policy_arns  = var.managed_policy_arns
}