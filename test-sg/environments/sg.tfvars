# Environment-specific variable values.
# Kebab-style map keys per naming convention.

# ── IAM Roles ────────────────────────────────────────────────────────────────
iam_roles = {
  # IAM execution role for the CSV Processor Step Functions state machine.
  "csv-processor-sfn-role" = {
    name                 = "StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv"
    path                 = "/"
    description          = ""
    max_session_duration = 3600
    assume_role_policy   = <<-EOT
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::281542942714:root","Service":"states.amazonaws.com"},"Action":"sts:AssumeRole"}]}
EOT

    # Inline policies keyed by policy name.
    inline_policies = {
      # CloudWatch log delivery permissions.
      "CloudWatchLogs" = <<-EOT
{"Version":"2012-10-17","Statement":[{"Action":["logs:CreateLogDelivery","logs:GetLogDelivery","logs:UpdateLogDelivery","logs:DeleteLogDelivery","logs:ListLogDeliveries","logs:PutResourcePolicy","logs:DescribeResourcePolicies","logs:DescribeLogGroups"],"Effect":"Allow","Resource":["*"]}]}
EOT
      # Allows starting child distributed-map executions.
      "StartExecutionPolicy" = <<-EOT
{"Version":"2012-10-17","Statement":[{"Action":["states:StartExecution"],"Effect":"Allow","Resource":"arn:aws:states:us-east-1:281542942714:stateMachine:CSVProcessorStateMachine*"}]}
EOT
      # Lambda invocation for both workflow functions.
      "InvokeLambdaPolicy" = <<-EOT
{"Version":"2012-10-17","Statement":[{"Action":["lambda:InvokeFunction"],"Effect":"Allow","Resource":["arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distr-DelayedOrderDetectorFunc-Ehw2w36vxu7i","arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distribut-CSVGeneratorFunction-IhOsmqsm7bTk"]}]}
EOT
      # S3 read access for the input shipping CSV bucket.
      "ReadDataPolicy" = <<-EOT
{"Version":"2012-10-17","Statement":[{"Action":["S3:GetObject"],"Effect":"Allow","Resource":["arn:aws:s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb","arn:aws:s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb/*"]}]}
EOT
      # SQS send-message permission for the delayed orders queue.
      "SQSSendPolicy" = <<-EOT
{"Version":"2012-10-17","Statement":[{"Action":["sqs:sendMessage"],"Effect":"Allow","Resource":["arn:aws:sqs:us-east-1:281542942714:StepFunctionsSample-DistributedMapCSVIterator-801-DelayedOrderQueue-uaiUtI359TU8"]}]}
EOT
      # S3 write access for execution result output buckets.
      "WriteResultsPolicy" = <<-EOT
{"Version":"2012-10-17","Statement":[{"Action":["S3:PutObject"],"Effect":"Allow","Resource":["arn:aws:s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb/*","arn:aws:s3:::stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz/*"]}]}
EOT
    }

    # AWS-managed policy attachments.
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/AWSXrayFullAccess",
    ]
  }
}

# ── Step Functions State Machines ─────────────────────────────────────────────
sfn_state_machines = {
  # Distributed-map CSV processor that detects delayed shipping orders.
  "csv-processor-state-machine" = {
    name            = "CSVProcessorStateMachine-Nq3DuFE2gSiF"
    type            = "STANDARD"
    role_arn        = "arn:aws:iam::281542942714:role/StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv"
    tracing_enabled = false

    # Amazon States Language definition — exact formatting as stored by the provider.
    definition = <<EOT
{
  "Comment": "Distributed map that reads CSV file for order data and detects delayed orders",
  "StartAt": "GenerateCSV",
  "QueryLanguage": "JSONata",
  "States": {
    "GenerateCSV": {
      "Comment": " This step is used to generate CSV file with contains order data",
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 3,
          "BackoffRate": 2
        }
      ],
      "Next": "Shipping File Analysis",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distribut-CSVGeneratorFunction-IhOsmqsm7bTk",
        "Payload": "{% $states.input %}"
      }
    },
    "Shipping File Analysis": {
      "Type": "Map",
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "DISTRIBUTED",
          "ExecutionType": "EXPRESS"
        },
        "StartAt": "DetectDelayedOrders",
        "States": {
          "DetectDelayedOrders": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
              }
            ],
            "Next": "ProcessDelayedOrders",
            "Output": "{% $states.result.Payload %}",
            "Arguments": {
              "FunctionName": "arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distr-DelayedOrderDetectorFunc-Ehw2w36vxu7i",
              "Payload": "{% $states.input %}"
            }
          },
          "ProcessDelayedOrders": {
            "Type": "Map",
            "ItemProcessor": {
              "ProcessorConfig": {
                "Mode": "INLINE"
              },
              "StartAt": "SendDelayedOrder",
              "States": {
                "SendDelayedOrder": {
                  "Type": "Task",
                  "Resource": "arn:aws:states:::sqs:sendMessage",
                  "End": true,
                  "Arguments": {
                    "QueueUrl": "https://sqs.us-east-1.amazonaws.com/281542942714/StepFunctionsSample-DistributedMapCSVIterator-801-DelayedOrderQueue-uaiUtI359TU8",
                    "MessageBody": "{% $states.input %}"
                  }
                }
              }
            },
            "End": true
          }
        }
      },
      "ItemReader": {
        "Resource": "arn:aws:states:::s3:getObject",
        "ReaderConfig": {
          "InputType": "CSV",
          "CSVHeaderLocation": "FIRST_ROW"
        },
        "Arguments": {
          "Bucket": "stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb",
          "Key": "shipping_data.csv"
        }
      },
      "MaxConcurrency": 1000,
      "Label": "ShippingFileAnalysis",
      "End": true,
      "ItemBatcher": {
        "MaxItemsPerBatch": 10
      },
      "ResultWriter": {
        "Resource": "arn:aws:states:::s3:putObject",
        "Arguments": {
          "Bucket": "stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz",
          "Prefix": "results"
        }
      }
    }
  }
}
EOT

    # CloudWatch logging: ERROR level, execution data excluded.
    logging_configuration = {
      level                  = "ERROR"
      include_execution_data = false
      log_destination        = "arn:aws:logs:us-east-1:281542942714:log-group:/aws/vendedlogs/states/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb:*"
    }
  }
}
