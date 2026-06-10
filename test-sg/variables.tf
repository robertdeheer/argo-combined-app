# Root variable declarations.
# All instance-specific values live in environments/sg.tfvars.

# ── IAM Roles ────────────────────────────────────────────────────────────────
variable "iam_roles" {
  description = "Map of IAM role instances keyed by a stable snake_case name."
  type = map(object({
    name                 = string
    path                 = optional(string, "/")
    description          = optional(string, "")
    assume_role_policy   = string
    max_session_duration = optional(number, 3600)
    permissions_boundary = optional(string, null)
    tags                 = optional(map(string), {})
    inline_policies      = optional(map(string), {})
    managed_policy_arns  = optional(list(string), [])
  }))
  default = {}
}

# ── Step Functions State Machines ─────────────────────────────────────────────
variable "sfn_state_machines" {
  description = "Map of Step Functions state machine instances keyed by a stable snake_case name."
  type = map(object({
    name       = string
    role_arn   = string
    definition = string
    type       = optional(string, "STANDARD")
    tags       = optional(map(string), {})
    logging_configuration = optional(object({
      level                  = string
      include_execution_data = bool
      log_destination        = string
    }), null)
    tracing_enabled = optional(bool, false)
  }))
  default = {}
}
