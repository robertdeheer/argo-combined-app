# Primary Step Functions state machine resource.
resource "aws_sfn_state_machine" "this" {
  name     = var.name
  role_arn = var.role_arn
  # chomp() strips the trailing newline that HCL heredoc syntax appends.
  definition = chomp(var.definition)
  type       = var.type
  tags       = var.tags

  # Logging configuration — only set when a destination is provided.
  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [var.logging_configuration] : []
    content {
      level                  = logging_configuration.value.level
      include_execution_data = logging_configuration.value.include_execution_data
      log_destination        = logging_configuration.value.log_destination
    }
  }

  # X-Ray tracing configuration.
  tracing_configuration {
    enabled = var.tracing_enabled
  }
}
