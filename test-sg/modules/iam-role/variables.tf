# Variables for the aws_iam_role module.
# Each variable maps directly to the corresponding Terraform argument.

variable "name" {
  description = "Name of the IAM role."
  type        = string
}

variable "path" {
  description = "Path for the IAM role."
  type        = string
  default     = "/"
}

variable "description" {
  description = "Description of the IAM role."
  type        = string
  default     = ""
}

variable "assume_role_policy" {
  description = "JSON-encoded trust policy document."
  type        = string
}

variable "max_session_duration" {
  description = "Maximum session duration (seconds)."
  type        = number
  default     = 3600
}

variable "permissions_boundary" {
  description = "ARN of the permissions boundary policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the role."
  type        = map(string)
  default     = {}
}

# ── Inline policies ──────────────────────────────────────────────────────────
variable "inline_policies" {
  description = "Map of inline policy name -> JSON policy document."
  type        = map(string)
  default     = {}
}

# ── Managed policy attachments ───────────────────────────────────────────────
variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach."
  type        = list(string)
  default     = []
}
