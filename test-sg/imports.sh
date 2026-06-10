#!/bin/sh
# Import discovered cloud resources into Terraform state.
# Usage: sh imports.sh /tmp/tmp.AinEFI/terraform
set -e

# IAM execution role for the CSV Processor Step Functions state machine.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role.this' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv'

# Inline policy: CloudWatch Logs permissions.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["CloudWatchLogs"]' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv:CloudWatchLogs'

# Inline policy: Step Functions start-execution permission.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["StartExecutionPolicy"]' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv:StartExecutionPolicy'

# Inline policy: Lambda invocation permission.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["InvokeLambdaPolicy"]' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv:InvokeLambdaPolicy'

# Inline policy: S3 read access for input CSV data.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["ReadDataPolicy"]' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv:ReadDataPolicy'

# Inline policy: SQS send-message permission for delayed orders queue.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["SQSSendPolicy"]' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv:SQSSendPolicy'

# Inline policy: S3 write access for execution result output.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["WriteResultsPolicy"]' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv:WriteResultsPolicy'

# Managed policy attachment: AWSXrayFullAccess.
"$1" import -var-file environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AWSXrayFullAccess"]' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv/arn:aws:iam::aws:policy/AWSXrayFullAccess'

# Step Functions state machine: CSV distributed-map processor.
"$1" import -var-file environments/sg.tfvars \
  'module.sfn-state-machine["csv-processor-state-machine"].aws_sfn_state_machine.this' \
  'arn:aws:states:us-east-1:281542942714:stateMachine:CSVProcessorStateMachine-Nq3DuFE2gSiF'
