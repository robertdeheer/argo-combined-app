variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "role_arn" {
  type        = string
  description = "ARN of the IAM execution role"
}

variable "handler" {
  type        = string
  description = "Function entry point"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime identifier"
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB"
}

variable "timeout" {
  type        = number
  description = "Function timeout in seconds"
}

variable "architectures" {
  type        = list(string)
  description = "Instruction set architecture"
}

variable "package_type" {
  type        = string
  description = "Lambda deployment package type"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the function"
}

variable "ephemeral_storage_size" {
  type        = number
  description = "Amount of ephemeral storage in MB"
}

variable "tracing_mode" {
  type        = string
  description = "X-Ray tracing mode"
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the function"
}