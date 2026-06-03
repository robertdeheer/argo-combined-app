variable "stack_name" {
  type        = string
  description = "Name of the CloudFormation stack"
}

variable "capabilities" {
  type        = list(string)
  description = "List of capabilities for the CloudFormation stack"
}

variable "disable_rollback" {
  type        = bool
  description = "Whether to disable rollback on stack creation failure"
}

variable "parameters" {
  type        = map(string)
  description = "Map of parameter key-value pairs for the stack"
}