output "arn" {
  description = "ARN of the state machine."
  value       = aws_sfn_state_machine.this.arn
}

output "name" {
  description = "Name of the state machine."
  value       = aws_sfn_state_machine.this.name
}
