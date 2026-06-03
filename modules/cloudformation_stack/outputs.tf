output "stack_id" {
  description = "ID of the CloudFormation stack"
  value       = aws_cloudformation_stack.this.id
}