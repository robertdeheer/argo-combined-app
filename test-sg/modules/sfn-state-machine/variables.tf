# Variables for the aws_sfn_state_machine module.

variable "name" {
  description = "Name of the Step Functions state machine."
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role to use for execution."
  type        = string
}

variable "definition" {
  description = "JSON-encoded state machine definition (Amazon States Language)."
  type        = string
}

variable "type" {
  description = "Type of the state machine: STANDARD or EXPRESS."
  type        = string
  default     = "STANDARD"
}

variable "tags" {
  description = "Tags to apply to the state machine."
  type        = map(string)
  default     = {}
}

# ── Logging ──────────────────────────────────────────────────────────────────
variable "logging_configuration" {
  description = "Logging configuration block."
  type = object({
    level                  = string
    include_execution_data = bool
    log_destination        = string # CloudWatch Logs group ARN with :* suffix
  })
  default = null
}

# ── Tracing ──────────────────────────────────────────────────────────────────
variable "tracing_enabled" {
  description = "Whether X-Ray tracing is enabled."
  type        = bool
  default     = false
}
