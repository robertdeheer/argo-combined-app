#!/bin/sh
set -e

"$1" import -var-file environments/sg.tfvars 'module.cloudformation_stack.aws_cloudformation_stack.this' 'StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb'
"$1" import -var-file environments/sg.tfvars 'module.iam_role_csv_generator.aws_iam_role.this' 'StepFunctionsSample-Distr-CSVGeneratorFunctionExecu-zYC00OhAGp9O'
"$1" import -var-file environments/sg.tfvars 'module.iam_role_csv_processor_state_machine.aws_iam_role.this' 'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv'
"$1" import -var-file environments/sg.tfvars 'module.iam_role_delayed_order_detector.aws_iam_role.this' 'StepFunctionsSample-Distr-DelayedOrderDetectorFunct-FClPYrezw4Ua'
"$1" import -var-file environments/sg.tfvars 'module.lambda_function_delayed_order_detector.aws_lambda_function.this' 'StepFunctionsSample-Distr-DelayedOrderDetectorFunc-Ehw2w36vxu7i'
"$1" import -var-file environments/sg.tfvars 'module.lambda_function_csv_generator.aws_lambda_function.this' 'StepFunctionsSample-Distribut-CSVGeneratorFunction-IhOsmqsm7bTk'
"$1" import -var-file environments/sg.tfvars 'module.s3_bucket_result.aws_s3_bucket.this' 'stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz'
"$1" import -var-file environments/sg.tfvars 'module.s3_bucket_input.aws_s3_bucket.this' 'stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb'
"$1" import -var-file environments/sg.tfvars 'module.sqs_queue.aws_sqs_queue.this' 'https://sqs.us-east-1.amazonaws.com/281542942714/StepFunctionsSample-DistributedMapCSVIterator-801-DelayedOrderQueue-uaiUtI359TU8'