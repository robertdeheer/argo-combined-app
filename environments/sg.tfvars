region = "us-east-1"

cloudformation_stack_name       = "StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb"
cloudformation_capabilities     = ["CAPABILITY_IAM"]
cloudformation_disable_rollback = false
cloudformation_parameters = {
  OrderDataFileName = "shipping_data.csv"
}

csv_generator_role_name                = "StepFunctionsSample-Distr-CSVGeneratorFunctionExecu-zYC00OhAGp9O"
csv_generator_role_path                = "/"
csv_generator_role_max_session_duration = 3600
csv_generator_role_assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
csv_generator_role_managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
csv_generator_inline_policy_name       = "LambaForDataGenerationExecutionPolicy"
csv_generator_inline_policy_document   = "{\"Statement\":[{\"Action\":[\"s3:PutObject\"],\"Effect\":\"Allow\",\"Resource\":\"arn:aws:s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb/*\"}],\"Version\":\"2012-10-17\"}"

csv_processor_sm_role_name                = "StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv"
csv_processor_sm_role_path                = "/"
csv_processor_sm_role_max_session_duration = 3600
csv_processor_sm_role_assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::281542942714:root\",\"Service\":\"states.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
csv_processor_sm_role_managed_policy_arns = ["arn:aws:iam::aws:policy/AWSXrayFullAccess"]

csv_processor_sm_inline_policy_cloudwatch_name          = "CloudWatchLogs"
csv_processor_sm_inline_policy_cloudwatch_document      = "{\"Statement\":[{\"Action\":[\"logs:CreateLogDelivery\",\"logs:GetLogDelivery\",\"logs:UpdateLogDelivery\",\"logs:DeleteLogDelivery\",\"logs:ListLogDeliveries\",\"logs:PutResourcePolicy\",\"logs:DescribeResourcePolicies\",\"logs:DescribeLogGroups\"],\"Effect\":\"Allow\",\"Resource\":[\"*\"]}],\"Version\":\"2012-10-17\"}"
csv_processor_sm_inline_policy_start_execution_name     = "StartExecutionPolicy"
csv_processor_sm_inline_policy_start_execution_document = "{\"Statement\":[{\"Action\":[\"states:StartExecution\"],\"Effect\":\"Allow\",\"Resource\":\"arn:aws:states:us-east-1:281542942714:stateMachine:CSVProcessorStateMachine*\"}],\"Version\":\"2012-10-17\"}"
csv_processor_sm_inline_policy_invoke_lambda_name       = "InvokeLambdaPolicy"
csv_processor_sm_inline_policy_invoke_lambda_document   = "{\"Statement\":[{\"Action\":[\"lambda:InvokeFunction\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distr-DelayedOrderDetectorFunc-Ehw2w36vxu7i\",\"arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distribut-CSVGeneratorFunction-IhOsmqsm7bTk\"]}],\"Version\":\"2012-10-17\"}"
csv_processor_sm_inline_policy_read_data_name           = "ReadDataPolicy"
csv_processor_sm_inline_policy_read_data_document       = "{\"Statement\":[{\"Action\":[\"S3:GetObject\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb\",\"arn:aws:s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb/*\"]}],\"Version\":\"2012-10-17\"}"
csv_processor_sm_inline_policy_sqs_send_name            = "SQSSendPolicy"
csv_processor_sm_inline_policy_sqs_send_document        = "{\"Statement\":[{\"Action\":[\"sqs:sendMessage\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:sqs:us-east-1:281542942714:StepFunctionsSample-DistributedMapCSVIterator-801-DelayedOrderQueue-uaiUtI359TU8\"]}],\"Version\":\"2012-10-17\"}"
csv_processor_sm_inline_policy_write_results_name       = "WriteResultsPolicy"
csv_processor_sm_inline_policy_write_results_document   = "{\"Statement\":[{\"Action\":[\"S3:PutObject\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb/*\",\"arn:aws:s3:::stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz/*\"]}],\"Version\":\"2012-10-17\"}"

delayed_order_detector_role_name                = "StepFunctionsSample-Distr-DelayedOrderDetectorFunct-FClPYrezw4Ua"
delayed_order_detector_role_path                = "/"
delayed_order_detector_role_max_session_duration = 3600
delayed_order_detector_role_assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
delayed_order_detector_role_managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

delayed_order_detector_function_name         = "StepFunctionsSample-Distr-DelayedOrderDetectorFunc-Ehw2w36vxu7i"
delayed_order_detector_handler               = "index.lambda_handler"
delayed_order_detector_runtime               = "python3.14"
delayed_order_detector_memory_size           = 2048
delayed_order_detector_timeout               = 600
delayed_order_detector_architectures         = ["x86_64"]
delayed_order_detector_package_type          = "Zip"
delayed_order_detector_environment_variables = {
  INPUT_BUCKET_NAME = "stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb"
}
delayed_order_detector_ephemeral_storage_size = 512
delayed_order_detector_tracing_mode           = "PassThrough"
delayed_order_detector_tags = {
  "aws:cloudformation:stack-name" = "StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb"
  "aws:cloudformation:logical-id" = "DelayedOrderDetectorFunction"
  "aws:cloudformation:stack-id"   = "arn:aws:cloudformation:us-east-1:281542942714:stack/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb/fd9c1fd0-594c-11f1-a547-0e9478a88f9f"
}

csv_generator_function_name         = "StepFunctionsSample-Distribut-CSVGeneratorFunction-IhOsmqsm7bTk"
csv_generator_handler               = "index.lambda_handler"
csv_generator_runtime               = "python3.14"
csv_generator_memory_size           = 2048
csv_generator_timeout               = 600
csv_generator_architectures         = ["x86_64"]
csv_generator_package_type          = "Zip"
csv_generator_environment_variables = {
  FILE_NAME         = "shipping_data.csv"
  INPUT_BUCKET_NAME = "stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb"
}
csv_generator_ephemeral_storage_size = 512
csv_generator_tracing_mode           = "PassThrough"
csv_generator_tags = {
  "aws:cloudformation:stack-name" = "StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb"
  "aws:cloudformation:logical-id" = "CSVGeneratorFunction"
  "aws:cloudformation:stack-id"   = "arn:aws:cloudformation:us-east-1:281542942714:stack/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb/fd9c1fd0-594c-11f1-a547-0e9478a88f9f"
}

result_bucket_name = "stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz"
result_bucket_tags = {
  "aws:cloudformation:stack-name" = "StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb"
  "aws:cloudformation:logical-id" = "ResultBucket"
  "aws:cloudformation:stack-id"   = "arn:aws:cloudformation:us-east-1:281542942714:stack/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb/fd9c1fd0-594c-11f1-a547-0e9478a88f9f"
}

input_bucket_name = "stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb"
input_bucket_tags = {
  "aws:cloudformation:stack-name" = "StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb"
  "aws:cloudformation:logical-id" = "InputBucket"
  "aws:cloudformation:stack-id"   = "arn:aws:cloudformation:us-east-1:281542942714:stack/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb/fd9c1fd0-594c-11f1-a547-0e9478a88f9f"
}

sqs_queue_name                 = "StepFunctionsSample-DistributedMapCSVIterator-801-DelayedOrderQueue-uaiUtI359TU8"
sqs_delay_seconds              = 0
sqs_fifo_queue                 = false
sqs_max_message_size           = 1048576
sqs_message_retention_seconds  = 345600
sqs_visibility_timeout_seconds = 30
sqs_managed_sse_enabled        = true