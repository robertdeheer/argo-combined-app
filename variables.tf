variable "region" {
  type        = string
  description = "AWS region"
}

variable "cloudformation_stack_name" {
  type        = string
  description = "Name of the CloudFormation stack"
}

variable "cloudformation_capabilities" {
  type        = list(string)
  description = "List of capabilities for the CloudFormation stack"
}

variable "cloudformation_disable_rollback" {
  type        = bool
  description = "Whether to disable rollback on stack creation failure"
}

variable "cloudformation_parameters" {
  type        = map(string)
  description = "Map of parameter key-value pairs for the stack"
}

variable "csv_generator_role_name" {
  type        = string
  description = "Name of the IAM role for CSV Generator Lambda"
}

variable "csv_generator_role_path" {
  type        = string
  description = "Path for the CSV Generator IAM role"
}

variable "csv_generator_role_max_session_duration" {
  type        = number
  description = "Maximum session duration in seconds for CSV Generator role"
}

variable "csv_generator_role_assume_role_policy" {
  type        = string
  description = "JSON assume role policy for CSV Generator role"
}

variable "csv_generator_role_managed_policy_arns" {
  type        = list(string)
  description = "Managed policy ARNs for CSV Generator role"
}

variable "csv_generator_inline_policy_name" {
  type        = string
  description = "Name of the inline policy for CSV Generator role"
}

variable "csv_generator_inline_policy_document" {
  type        = string
  description = "JSON inline policy document for CSV Generator role"
}

variable "csv_processor_sm_role_name" {
  type        = string
  description = "Name of the IAM role for CSV Processor State Machine"
}

variable "csv_processor_sm_role_path" {
  type        = string
  description = "Path for the CSV Processor State Machine IAM role"
}

variable "csv_processor_sm_role_max_session_duration" {
  type        = number
  description = "Maximum session duration in seconds for CSV Processor SM role"
}

variable "csv_processor_sm_role_assume_role_policy" {
  type        = string
  description = "JSON assume role policy for CSV Processor SM role"
}

variable "csv_processor_sm_role_managed_policy_arns" {
  type        = list(string)
  description = "Managed policy ARNs for CSV Processor SM role"
}

variable "csv_processor_sm_inline_policy_cloudwatch_name" {
  type        = string
  description = "Name of the CloudWatch Logs inline policy"
}

variable "csv_processor_sm_inline_policy_cloudwatch_document" {
  type        = string
  description = "JSON document for CloudWatch Logs inline policy"
}

variable "csv_processor_sm_inline_policy_start_execution_name" {
  type        = string
  description = "Name of the StartExecution inline policy"
}

variable "csv_processor_sm_inline_policy_start_execution_document" {
  type        = string
  description = "JSON document for StartExecution inline policy"
}

variable "csv_processor_sm_inline_policy_invoke_lambda_name" {
  type        = string
  description = "Name of the InvokeLambda inline policy"
}

variable "csv_processor_sm_inline_policy_invoke_lambda_document" {
  type        = string
  description = "JSON document for InvokeLambda inline policy"
}

variable "csv_processor_sm_inline_policy_read_data_name" {
  type        = string
  description = "Name of the ReadData inline policy"
}

variable "csv_processor_sm_inline_policy_read_data_document" {
  type        = string
  description = "JSON document for ReadData inline policy"
}

variable "csv_processor_sm_inline_policy_sqs_send_name" {
  type        = string
  description = "Name of the SQSSend inline policy"
}

variable "csv_processor_sm_inline_policy_sqs_send_document" {
  type        = string
  description = "JSON document for SQSSend inline policy"
}

variable "csv_processor_sm_inline_policy_write_results_name" {
  type        = string
  description = "Name of the WriteResults inline policy"
}

variable "csv_processor_sm_inline_policy_write_results_document" {
  type        = string
  description = "JSON document for WriteResults inline policy"
}

variable "delayed_order_detector_role_name" {
  type        = string
  description = "Name of the IAM role for Delayed Order Detector Lambda"
}

variable "delayed_order_detector_role_path" {
  type        = string
  description = "Path for the Delayed Order Detector IAM role"
}

variable "delayed_order_detector_role_max_session_duration" {
  type        = number
  description = "Maximum session duration in seconds for Delayed Order Detector role"
}

variable "delayed_order_detector_role_assume_role_policy" {
  type        = string
  description = "JSON assume role policy for Delayed Order Detector role"
}

variable "delayed_order_detector_role_managed_policy_arns" {
  type        = list(string)
  description = "Managed policy ARNs for Delayed Order Detector role"
}

variable "delayed_order_detector_function_name" {
  type        = string
  description = "Name of the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_handler" {
  type        = string
  description = "Handler for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_runtime" {
  type        = string
  description = "Runtime for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_memory_size" {
  type        = number
  description = "Memory size in MB for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_timeout" {
  type        = number
  description = "Timeout in seconds for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_architectures" {
  type        = list(string)
  description = "Architectures for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_package_type" {
  type        = string
  description = "Package type for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_environment_variables" {
  type        = map(string)
  description = "Environment variables for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_ephemeral_storage_size" {
  type        = number
  description = "Ephemeral storage size in MB for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_tracing_mode" {
  type        = string
  description = "X-Ray tracing mode for the Delayed Order Detector Lambda function"
}

variable "delayed_order_detector_tags" {
  type        = map(string)
  description = "Tags for the Delayed Order Detector Lambda function"
}

variable "csv_generator_function_name" {
  type        = string
  description = "Name of the CSV Generator Lambda function"
}

variable "csv_generator_handler" {
  type        = string
  description = "Handler for the CSV Generator Lambda function"
}

variable "csv_generator_runtime" {
  type        = string
  description = "Runtime for the CSV Generator Lambda function"
}

variable "csv_generator_memory_size" {
  type        = number
  description = "Memory size in MB for the CSV Generator Lambda function"
}

variable "csv_generator_timeout" {
  type        = number
  description = "Timeout in seconds for the CSV Generator Lambda function"
}

variable "csv_generator_architectures" {
  type        = list(string)
  description = "Architectures for the CSV Generator Lambda function"
}

variable "csv_generator_package_type" {
  type        = string
  description = "Package type for the CSV Generator Lambda function"
}

variable "csv_generator_environment_variables" {
  type        = map(string)
  description = "Environment variables for the CSV Generator Lambda function"
}

variable "csv_generator_ephemeral_storage_size" {
  type        = number
  description = "Ephemeral storage size in MB for the CSV Generator Lambda function"
}

variable "csv_generator_tracing_mode" {
  type        = string
  description = "X-Ray tracing mode for the CSV Generator Lambda function"
}

variable "csv_generator_tags" {
  type        = map(string)
  description = "Tags for the CSV Generator Lambda function"
}

variable "result_bucket_name" {
  type        = string
  description = "Name of the S3 result bucket"
}

variable "result_bucket_tags" {
  type        = map(string)
  description = "Tags for the S3 result bucket"
}

variable "input_bucket_name" {
  type        = string
  description = "Name of the S3 input bucket"
}

variable "input_bucket_tags" {
  type        = map(string)
  description = "Tags for the S3 input bucket"
}

variable "sqs_queue_name" {
  type        = string
  description = "Name of the SQS queue"
}

variable "sqs_delay_seconds" {
  type        = number
  description = "Delivery delay in seconds for the SQS queue"
}

variable "sqs_fifo_queue" {
  type        = bool
  description = "Whether the SQS queue is a FIFO queue"
}

variable "sqs_max_message_size" {
  type        = number
  description = "Maximum message size in bytes for the SQS queue"
}

variable "sqs_message_retention_seconds" {
  type        = number
  description = "Message retention period in seconds for the SQS queue"
}

variable "sqs_visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout in seconds for the SQS queue"
}

variable "sqs_managed_sse_enabled" {
  type        = bool
  description = "Whether SQS-managed SSE is enabled"
}