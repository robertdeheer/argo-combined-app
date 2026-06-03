output "cloudformation_stack_id" {
  description = "ID of the CloudFormation stack"
  value       = module.cloudformation_stack.stack_id
}

output "csv_generator_role_arn" {
  description = "ARN of the CSV Generator IAM role"
  value       = module.iam_role_csv_generator.role_arn
}

output "csv_processor_sm_role_arn" {
  description = "ARN of the CSV Processor State Machine IAM role"
  value       = module.iam_role_csv_processor_state_machine.role_arn
}

output "delayed_order_detector_role_arn" {
  description = "ARN of the Delayed Order Detector IAM role"
  value       = module.iam_role_delayed_order_detector.role_arn
}

output "delayed_order_detector_function_arn" {
  description = "ARN of the Delayed Order Detector Lambda function"
  value       = module.lambda_function_delayed_order_detector.function_arn
}

output "csv_generator_function_arn" {
  description = "ARN of the CSV Generator Lambda function"
  value       = module.lambda_function_csv_generator.function_arn
}

output "result_bucket_arn" {
  description = "ARN of the S3 result bucket"
  value       = module.s3_bucket_result.bucket_arn
}

output "input_bucket_arn" {
  description = "ARN of the S3 input bucket"
  value       = module.s3_bucket_input.bucket_arn
}

output "delayed_order_queue_url" {
  description = "URL of the delayed order SQS queue"
  value       = module.sqs_queue.queue_url
}

output "delayed_order_queue_arn" {
  description = "ARN of the delayed order SQS queue"
  value       = module.sqs_queue.queue_arn
}