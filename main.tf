module "cloudformation_stack" {
  source = "./modules/cloudformation_stack"

  stack_name       = var.cloudformation_stack_name
  capabilities     = var.cloudformation_capabilities
  disable_rollback = var.cloudformation_disable_rollback
  parameters       = var.cloudformation_parameters
}

module "iam_role_csv_generator" {
  source = "./modules/iam_role_csv_generator"

  role_name              = var.csv_generator_role_name
  path                   = var.csv_generator_role_path
  max_session_duration   = var.csv_generator_role_max_session_duration
  assume_role_policy     = var.csv_generator_role_assume_role_policy
  managed_policy_arns    = var.csv_generator_role_managed_policy_arns
  inline_policy_name     = var.csv_generator_inline_policy_name
  inline_policy_document = var.csv_generator_inline_policy_document
}

module "iam_role_csv_processor_state_machine" {
  source = "./modules/iam_role_csv_processor_state_machine"

  role_name                              = var.csv_processor_sm_role_name
  path                                   = var.csv_processor_sm_role_path
  max_session_duration                   = var.csv_processor_sm_role_max_session_duration
  assume_role_policy                     = var.csv_processor_sm_role_assume_role_policy
  managed_policy_arns                    = var.csv_processor_sm_role_managed_policy_arns
  inline_policy_cloudwatch_name          = var.csv_processor_sm_inline_policy_cloudwatch_name
  inline_policy_cloudwatch_document      = var.csv_processor_sm_inline_policy_cloudwatch_document
  inline_policy_start_execution_name     = var.csv_processor_sm_inline_policy_start_execution_name
  inline_policy_start_execution_document = var.csv_processor_sm_inline_policy_start_execution_document
  inline_policy_invoke_lambda_name       = var.csv_processor_sm_inline_policy_invoke_lambda_name
  inline_policy_invoke_lambda_document   = var.csv_processor_sm_inline_policy_invoke_lambda_document
  inline_policy_read_data_name           = var.csv_processor_sm_inline_policy_read_data_name
  inline_policy_read_data_document       = var.csv_processor_sm_inline_policy_read_data_document
  inline_policy_sqs_send_name            = var.csv_processor_sm_inline_policy_sqs_send_name
  inline_policy_sqs_send_document        = var.csv_processor_sm_inline_policy_sqs_send_document
  inline_policy_write_results_name       = var.csv_processor_sm_inline_policy_write_results_name
  inline_policy_write_results_document   = var.csv_processor_sm_inline_policy_write_results_document
}

module "iam_role_delayed_order_detector" {
  source = "./modules/iam_role_delayed_order_detector"

  role_name            = var.delayed_order_detector_role_name
  path                 = var.delayed_order_detector_role_path
  max_session_duration = var.delayed_order_detector_role_max_session_duration
  assume_role_policy   = var.delayed_order_detector_role_assume_role_policy
  managed_policy_arns  = var.delayed_order_detector_role_managed_policy_arns
}

module "lambda_function_delayed_order_detector" {
  source = "./modules/lambda_function_delayed_order_detector"

  function_name          = var.delayed_order_detector_function_name
  role_arn               = module.iam_role_delayed_order_detector.role_arn
  handler                = var.delayed_order_detector_handler
  runtime                = var.delayed_order_detector_runtime
  memory_size            = var.delayed_order_detector_memory_size
  timeout                = var.delayed_order_detector_timeout
  architectures          = var.delayed_order_detector_architectures
  package_type           = var.delayed_order_detector_package_type
  environment_variables  = var.delayed_order_detector_environment_variables
  ephemeral_storage_size = var.delayed_order_detector_ephemeral_storage_size
  tracing_mode           = var.delayed_order_detector_tracing_mode
  tags                   = var.delayed_order_detector_tags
}

module "lambda_function_csv_generator" {
  source = "./modules/lambda_function_csv_generator"

  function_name          = var.csv_generator_function_name
  role_arn               = module.iam_role_csv_generator.role_arn
  handler                = var.csv_generator_handler
  runtime                = var.csv_generator_runtime
  memory_size            = var.csv_generator_memory_size
  timeout                = var.csv_generator_timeout
  architectures          = var.csv_generator_architectures
  package_type           = var.csv_generator_package_type
  environment_variables  = var.csv_generator_environment_variables
  ephemeral_storage_size = var.csv_generator_ephemeral_storage_size
  tracing_mode           = var.csv_generator_tracing_mode
  tags                   = var.csv_generator_tags
}

module "s3_bucket_result" {
  source = "./modules/s3_bucket_result"

  bucket_name = var.result_bucket_name
  tags        = var.result_bucket_tags
}

module "s3_bucket_input" {
  source = "./modules/s3_bucket_input"

  bucket_name = var.input_bucket_name
  tags        = var.input_bucket_tags
}

module "sqs_queue" {
  source = "./modules/sqs_queue"

  queue_name                 = var.sqs_queue_name
  delay_seconds              = var.sqs_delay_seconds
  fifo_queue                 = var.sqs_fifo_queue
  max_message_size           = var.sqs_max_message_size
  message_retention_seconds  = var.sqs_message_retention_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled
}