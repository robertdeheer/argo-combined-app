# step-functions-distributed-map-csv-iterator

## Description

AWS Step Functions sample project using Distributed Map that processes CSV file to find shipping delays for orders, including Lambda functions, IAM roles, S3 buckets, SQS queue, and CloudFormation stack.

## Architecture Overview

This stack manages the following AWS resources:

- **CloudFormation Stack**: The parent CloudFormation stack for the Distributed Map CSV Iterator sample project
- **IAM Roles**: Three execution roles for the CSV Generator Lambda, CSV Processor State Machine, and Delayed Order Detector Lambda
- **Lambda Functions**: Two Lambda functions — CSV Generator and Delayed Order Detector
- **S3 Buckets**: Input bucket (CSV data) and Result bucket (output)
- **SQS Queue**: Queue for delayed order notifications

## Module Overview

| Module | Description |
|--------|-------------|
| `cloudformation_stack` | Manages the CloudFormation stack |
| `iam_role_csv_generator` | IAM role for CSV Generator Lambda |
| `iam_role_csv_processor_state_machine` | IAM role for CSV Processor State Machine (6 inline policies) |
| `iam_role_delayed_order_detector` | IAM role for Delayed Order Detector Lambda |
| `lambda_function_delayed_order_detector` | Delayed Order Detector Lambda function |
| `lambda_function_csv_generator` | CSV Generator Lambda function |
| `s3_bucket_result` | S3 bucket for results |
| `s3_bucket_input` | S3 bucket for input CSV data |
| `sqs_queue` | SQS queue for delayed orders |

## Variables Reference

| Variable | Type | Description |
|----------|------|-------------|
| `region` | string | AWS region |
| `cloudformation_stack_name` | string | Name of the CloudFormation stack |
| `cloudformation_capabilities` | list(string) | Capabilities for the CloudFormation stack |
| `cloudformation_disable_rollback` | bool | Whether to disable rollback |
| `cloudformation_parameters` | map(string) | CloudFormation stack parameters |
| `csv_generator_role_name` | string | IAM role name for CSV Generator |
| `csv_generator_role_path` | string | IAM role path for CSV Generator |
| `csv_generator_role_max_session_duration` | number | Max session duration for CSV Generator role |
| `csv_generator_role_assume_role_policy` | string | Assume role policy for CSV Generator |
| `csv_generator_role_managed_policy_arns` | list(string) | Managed policies for CSV Generator role |
| `csv_generator_inline_policy_name` | string | Inline policy name for CSV Generator role |
| `csv_generator_inline_policy_document` | string | Inline policy document for CSV Generator role |
| `csv_processor_sm_role_name` | string | IAM role name for CSV Processor SM |
| `csv_processor_sm_role_path` | string | IAM role path for CSV Processor SM |
| `csv_processor_sm_role_max_session_duration` | number | Max session duration for CSV Processor SM role |
| `csv_processor_sm_role_assume_role_policy` | string | Assume role policy for CSV Processor SM |
| `csv_processor_sm_role_managed_policy_arns` | list(string) | Managed policies for CSV Processor SM role |
| `csv_processor_sm_inline_policy_*` | string | Various inline policy names and documents |
| `delayed_order_detector_role_name` | string | IAM role name for Delayed Order Detector |
| `delayed_order_detector_function_name` | string | Lambda function name for Delayed Order Detector |
| `delayed_order_detector_runtime` | string | Lambda runtime |
| `delayed_order_detector_*` | various | Other Delayed Order Detector Lambda settings |
| `csv_generator_function_name` | string | Lambda function name for CSV Generator |
| `csv_generator_runtime` | string | Lambda runtime |
| `csv_generator_*` | various | Other CSV Generator Lambda settings |
| `result_bucket_name` | string | S3 result bucket name |
| `result_bucket_tags` | map(string) | Tags for result bucket |
| `input_bucket_name` | string | S3 input bucket name |
| `input_bucket_tags` | map(string) | Tags for input bucket |
| `sqs_queue_name` | string | SQS queue name |
| `sqs_delay_seconds` | number | SQS delivery delay |
| `sqs_fifo_queue` | bool | Whether queue is FIFO |
| `sqs_max_message_size` | number | Max message size in bytes |
| `sqs_message_retention_seconds` | number | Message retention period |
| `sqs_visibility_timeout_seconds` | number | Visibility timeout |
| `sqs_managed_sse_enabled` | bool | Whether SQS-managed SSE is enabled |

## Outputs Reference

| Output | Description |
|--------|-------------|
| `cloudformation_stack_id` | ID of the CloudFormation stack |
| `csv_generator_role_arn` | ARN of the CSV Generator IAM role |
| `csv_processor_sm_role_arn` | ARN of the CSV Processor State Machine IAM role |
| `delayed_order_detector_role_arn` | ARN of the Delayed Order Detector IAM role |
| `delayed_order_detector_function_arn` | ARN of the Delayed Order Detector Lambda function |
| `csv_generator_function_arn` | ARN of the CSV Generator Lambda function |
| `result_bucket_arn` | ARN of the S3 result bucket |
| `input_bucket_arn` | ARN of the S3 input bucket |
| `delayed_order_queue_url` | URL of the delayed order SQS queue |
| `delayed_order_queue_arn` | ARN of the delayed order SQS queue |

## Usage Instructions

### 1. Initialize

```sh
terraform init
```

### 2. Import Existing Resources

```sh
chmod +x imports.sh
./imports.sh terraform
```

### 3. Plan

```sh
terraform plan -var-file environments/sg.tfvars
```

### 4. Apply

```sh
terraform apply -var-file environments/sg.tfvars
```