resource "aws_cloudformation_stack" "this" {
  name             = var.stack_name
  capabilities     = var.capabilities
  disable_rollback = var.disable_rollback
  parameters       = var.parameters
}