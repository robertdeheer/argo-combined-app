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

variable "inline_policy_cloudwatch_name" {
  type        = string
  description = "Name of the CloudWatch Logs inline policy"
}

variable "inline_policy_cloudwatch_document" {
  type        = string
  description = "JSON document for CloudWatch Logs inline policy"
}

variable "inline_policy_start_execution_name" {
  type        = string
  description = "Name of the StartExecution inline policy"
}

variable "inline_policy_start_execution_document" {
  type        = string
  description = "JSON document for StartExecution inline policy"
}

variable "inline_policy_invoke_lambda_name" {
  type        = string
  description = "Name of the InvokeLambda inline policy"
}

variable "inline_policy_invoke_lambda_document" {
  type        = string
  description = "JSON document for InvokeLambda inline policy"
}

variable "inline_policy_read_data_name" {
  type        = string
  description = "Name of the ReadData inline policy"
}

variable "inline_policy_read_data_document" {
  type        = string
  description = "JSON document for ReadData inline policy"
}

variable "inline_policy_sqs_send_name" {
  type        = string
  description = "Name of the SQSSend inline policy"
}

variable "inline_policy_sqs_send_document" {
  type        = string
  description = "JSON document for SQSSend inline policy"
}

variable "inline_policy_write_results_name" {
  type        = string
  description = "Name of the WriteResults inline policy"
}

variable "inline_policy_write_results_document" {
  type        = string
  description = "JSON document for WriteResults inline policy"
}