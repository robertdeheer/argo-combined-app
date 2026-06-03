variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "path" {
  type        = string
  description = "Path for the IAM role"
}

variable "max_session_duration" {
  type        = number
  description = "Maximum session duration in seconds"
}

variable "assume_role_policy" {
  type        = string
  description = "JSON assume role policy document"
}

variable "managed_policy_arns" {
  type        = list(string)
  description = "List of managed policy ARNs to attach"
}

variable "inline_policy_name" {
  type        = string
  description = "Name of the inline policy"
}

variable "inline_policy_document" {
  type        = string
  description = "JSON inline policy document"
}