# CSV Processor Step Functions Infrastructure

## 1. Overview

This Terraform code manages a serverless workflow that processes CSV order data using AWS Step Functions with distributed map execution. The infrastructure was generated from discovered cloud resources in AWS account `281542942714` (us-east-1) and reconciled via `terraform import` until the plan showed no changes (0/0/0).

The stack consists of:

- **1 IAM execution role** with 6 inline policies and 1 managed policy attachment
- **1 Step Functions state machine** (STANDARD type) that orchestrates a distributed-map CSV processor

The state machine workflow:
1. Invokes a Lambda function to generate CSV data containing order information
2. Uses a distributed map to read the CSV file from S3, processing rows in batches of up to 10 items with 1000 max concurrent batches
3. For each batch, invokes a Lambda function to detect delayed orders
4. Sends detected delayed orders to an SQS queue for further processing
5. Writes execution results back to S3

The infrastructure is managed entirely via Terraform/OpenTofu; no resources were manually created after import. The code applies environment-specific values from `environments/sg.tfvars` with no hardcoded configuration.

---

## 2. Resources

| Terraform Address | Type | Real-World Name / ID | Purpose |
|---|---|---|---|
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role.this` | `aws_iam_role` | `StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv` | IAM execution role for the Step Functions state machine; assumes trust with `states.amazonaws.com` service and account root |
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["CloudWatchLogs"]` | `aws_iam_role_policy` | (inline) `CloudWatchLogs` | Allows state machine to create and manage CloudWatch log groups and deliveries |
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["StartExecutionPolicy"]` | `aws_iam_role_policy` | (inline) `StartExecutionPolicy` | Permits starting child distributed-map executions for state machines matching `arn:aws:states:us-east-1:*:stateMachine:CSVProcessorStateMachine*` |
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["InvokeLambdaPolicy"]` | `aws_iam_role_policy` | (inline) `InvokeLambdaPolicy` | Grants `lambda:InvokeFunction` permission for both CSV generator and delayed order detector Lambda functions |
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["ReadDataPolicy"]` | `aws_iam_role_policy` | (inline) `ReadDataPolicy` | Allows reading the input CSV file (`shipping_data.csv`) from the input S3 bucket |
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["SQSSendPolicy"]` | `aws_iam_role_policy` | (inline) `SQSSendPolicy` | Permits sending messages to the delayed orders SQS queue |
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["WriteResultsPolicy"]` | `aws_iam_role_policy` | (inline) `WriteResultsPolicy` | Grants `s3:PutObject` permission for writing results to the output S3 bucket and input bucket |
| `module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AWSXrayFullAccess"]` | `aws_iam_role_policy_attachment` | (managed) `arn:aws:iam::aws:policy/AWSXrayFullAccess` | Attaches AWS-managed X-Ray policy for distributed tracing (currently disabled in state machine config) |
| `module.sfn-state-machine["csv-processor-state-machine"].aws_sfn_state_machine.this` | `aws_sfn_state_machine` | `CSVProcessorStateMachine-Nq3DuFE2gSiF` | STANDARD state machine that orchestrates the distributed-map CSV processing workflow; logs errors to CloudWatch |

---

## 3. Module Structure

### `modules/iam-role/`

Local module that provisions an IAM role with inline and managed policies.

**Resources:**
- `aws_iam_role.this` — The role itself
- `aws_iam_role_policy.this[for_each]` — Child resources, one per inline policy (keys: policy names)
- `aws_iam_role_policy_attachment.this[for_each]` — Child resources, one per managed policy ARN

**Inputs:**
- `name` (required) — Role name
- `path` (default: `/`) — IAM path
- `description` (default: `""`)
- `assume_role_policy` (required) — JSON trust policy document
- `max_session_duration` (default: 3600 seconds)
- `permissions_boundary` (default: `null`)
- `tags` (default: `{}`)
- `inline_policies` (default: `{}`) — Map of `policy_name → JSON policy document`
- `managed_policy_arns` (default: `[]`) — List of managed policy ARNs to attach

**Outputs:**
- `arn` — Role ARN
- `name` — Role name

### `modules/sfn-state-machine/`

Local module that provisions a Step Functions state machine with optional logging and X-Ray tracing.

**Resources:**
- `aws_sfn_state_machine.this` — The state machine itself

**Inputs:**
- `name` (required) — State machine name
- `role_arn` (required) — IAM role ARN for execution
- `definition` (required) — JSON-encoded Amazon States Language definition
- `type` (default: `STANDARD`) — Machine type: `STANDARD` or `EXPRESS`
- `tags` (default: `{}`)
- `logging_configuration` (default: `null`) — Object with keys: `level`, `include_execution_data`, `log_destination` (CloudWatch log group ARN)
- `tracing_enabled` (default: `false`) — Enable X-Ray tracing

**Outputs:**
- `arn` — State machine ARN
- `name` — State machine name

**Implementation notes:**
- Uses `chomp(var.definition)` to strip the trailing newline appended by HCL heredoc syntax, ensuring the definition matches cloud state exactly
- Uses `dynamic "logging_configuration"` block to conditionally include logging only when `logging_configuration` is not null

---

## 4. How Import Works

The file `imports.sh` maps each Terraform address to its cloud resource ID and must be run once to populate state. The script uses `terraform import` with the `-var-file=environments/sg.tfvars` flag to load configuration before importing.

**Import sequence (in `imports.sh`):**

1. **IAM Role** — Import role by name: `StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv`
2. **Inline Policies** (6 policies) — Import each as `role_name:policy_name`
   - CloudWatchLogs
   - StartExecutionPolicy
   - InvokeLambdaPolicy
   - ReadDataPolicy
   - SQSSendPolicy
   - WriteResultsPolicy
3. **Managed Policy Attachment** — Import as `role_name/policy_arn`
4. **State Machine** — Import by full ARN: `arn:aws:states:us-east-1:281542942714:stateMachine:CSVProcessorStateMachine-Nq3DuFE2gSiF`

**Do not re-run `imports.sh`** unless state is lost or the infrastructure is destroyed and rebuilt. To re-import a single resource (e.g., if state becomes stale):

```bash
terraform import -var-file=environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role.this' \
  'StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv'
```

Or for a policy:

```bash
terraform import -var-file=environments/sg.tfvars \
  'module.iam-role["csv-processor-sfn-role"].aws_iam_role_policy.this["PolicyName"]' \
  'RoleName:PolicyName'
```

---

## 5. How to Use the Code

### Prerequisites

- OpenTofu or Terraform binary (path: `/tmp/tmp.AinEFI/terraform`)
- AWS credentials configured (account `281542942714`, region `us-east-1`)
- Working directory: `/mnt/sg_workspace/user/sgcode`

### Initialize Terraform

```bash
cd /mnt/sg_workspace/user/sgcode
terraform init
```

This initializes the local backend and downloads provider plugins.

### Plan Changes

```bash
terraform plan -var-file=environments/sg.tfvars
```

With the current code and tfvars, this should show **0 changes** (reconciliation complete).

### Apply Changes

```bash
terraform apply -var-file=environments/sg.tfvars
```

Prompts for confirmation before applying any changes.

### Apply Without Prompting

```bash
terraform apply -var-file=environments/sg.tfvars -auto-approve
```

### Targeting a Specific Resource

To update only the state machine:

```bash
terraform plan -var-file=environments/sg.tfvars \
  -target='module.sfn-state-machine["csv-processor-state-machine"]'
```

### Using a Different Environment

To deploy to a different environment (e.g., `dev` instead of `sg`):

1. **Create a new tfvars file** by copying `environments/sg.tfvars`:
   ```bash
   cp environments/sg.tfvars environments/dev.tfvars
   ```

2. **Edit the copy** with environment-specific values:
   ```hcl
   iam_roles = {
     "csv-processor-sfn-role" = {
       name = "DevCSVProcessorRole"
       # ... other fields ...
     }
   }
   sfn_state_machines = {
     "csv-processor-state-machine" = {
       name    = "DevCSVProcessor"
       role_arn = "arn:aws:iam::ACCOUNT:role/DevCSVProcessorRole"
       # ... other fields ...
     }
   }
   ```

3. **Plan and apply with the new file**:
   ```bash
   terraform plan -var-file=environments/dev.tfvars
   terraform apply -var-file=environments/dev.tfvars -auto-approve
   ```

**No `.tf` file modifications are required** — all configuration lives in the tfvars files.

---

## 6. Variables

All variables are defined in `variables.tf` at the root level and populated from `environments/sg.tfvars`. No variables are marked sensitive in this stack.

### Root Variables

#### `iam_roles`

**Type:** `map(object({...}))`  
**Default:** `{}`  
**Required:** Yes (populated from tfvars)

Map of IAM role instances, keyed by kebab-case identifier. Each role object contains:

- `name` (string, required) — Name of the IAM role
- `path` (string, optional, default: `"/"`) — IAM path prefix
- `description` (string, optional, default: `""`)
- `assume_role_policy` (string, required) — JSON trust policy document (who can assume the role)
- `max_session_duration` (number, optional, default: 3600) — Maximum session duration in seconds
- `permissions_boundary` (string, optional, default: null) — ARN of permissions boundary policy (restricts max permissions)
- `tags` (map(string), optional, default: `{}`) — Tags for the role
- `inline_policies` (map(string), optional, default: `{}`) — Inline policies, keyed by policy name; values are JSON policy documents
- `managed_policy_arns` (list(string), optional, default: `[]`) — ARNs of managed policies to attach

**Current value (from sg.tfvars):**
```hcl
iam_roles = {
  "csv-processor-sfn-role" = {
    name                 = "StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv"
    path                 = "/"
    description          = ""
    assume_role_policy   = "..." # JSON trust policy
    max_session_duration = 3600
    inline_policies = {
      "CloudWatchLogs"        = "..." # JSON policy
      "StartExecutionPolicy"  = "..." # JSON policy
      "InvokeLambdaPolicy"    = "..." # JSON policy
      "ReadDataPolicy"        = "..." # JSON policy
      "SQSSendPolicy"         = "..." # JSON policy
      "WriteResultsPolicy"    = "..." # JSON policy
    }
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/AWSXrayFullAccess"
    ]
  }
}
```

#### `sfn_state_machines`

**Type:** `map(object({...}))`  
**Default:** `{}`  
**Required:** Yes (populated from tfvars)

Map of Step Functions state machine instances, keyed by kebab-case identifier. Each state machine object contains:

- `name` (string, required) — Name of the state machine
- `role_arn` (string, required) — ARN of the IAM role for execution
- `definition` (string, required) — JSON-encoded Amazon States Language definition
- `type` (string, optional, default: `"STANDARD"`) — Type: `"STANDARD"` or `"EXPRESS"`
- `tags` (map(string), optional, default: `{}`) — Tags for the state machine
- `logging_configuration` (object, optional, default: null) — Logging settings with keys:
  - `level` (string) — Log level: `"ERROR"`, `"ALL"`, or `"OFF"`
  - `include_execution_data` (bool) — Whether to include input/output data in logs
  - `log_destination` (string) — CloudWatch log group ARN (including `:*` suffix)
- `tracing_enabled` (bool, optional, default: false) — Enable X-Ray tracing

**Current value (from sg.tfvars):**
```hcl
sfn_state_machines = {
  "csv-processor-state-machine" = {
    name            = "CSVProcessorStateMachine-Nq3DuFE2gSiF"
    type            = "STANDARD"
    role_arn        = "arn:aws:iam::281542942714:role/StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv"
    tracing_enabled = false
    definition      = "..." # Full JSON ASL definition (174 lines)
    logging_configuration = {
      level                  = "ERROR"
      include_execution_data = false
      log_destination        = "arn:aws:logs:us-east-1:281542942714:log-group:/aws/vendedlogs/states/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb:*"
    }
  }
}
```

### Variable Sources

- **No `.auto.tfvars` file created:** All values come from `-var-file=environments/sg.tfvars`
- **No `secrets.auto.tfvars` file:** No sensitive variables (credentials, API keys, etc.) were discovered in the cloud resources
- **No `-var` overrides required** to plan or apply the current configuration

---

## 7. Infrastructure Graph

```
module.iam-role["csv-processor-sfn-role"]
│
├── aws_iam_role.this (StepFunctionsSample-Distr-CSVProcessorStateMachineE-1OZiiv44FKvv)
│
├── aws_iam_role_policy.this["CloudWatchLogs"]
│   └── (references aws_iam_role.this)
│
├── aws_iam_role_policy.this["StartExecutionPolicy"]
│   └── (references aws_iam_role.this)
│
├── aws_iam_role_policy.this["InvokeLambdaPolicy"]
│   └── (references aws_iam_role.this)
│       └── Permits invocation of:
│           ├── arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distribut-CSVGeneratorFunction-IhOsmqsm7bTk
│           └── arn:aws:lambda:us-east-1:281542942714:function:StepFunctionsSample-Distr-DelayedOrderDetectorFunc-Ehw2w36vxu7i
│
├── aws_iam_role_policy.this["ReadDataPolicy"]
│   └── (references aws_iam_role.this)
│       └── Permits read from:
│           └── s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb (shipping_data.csv)
│
├── aws_iam_role_policy.this["SQSSendPolicy"]
│   └── (references aws_iam_role.this)
│       └── Permits send-message to:
│           └── arn:aws:sqs:us-east-1:281542942714:StepFunctionsSample-DistributedMapCSVIterator-801-DelayedOrderQueue-uaiUtI359TU8
│
├── aws_iam_role_policy.this["WriteResultsPolicy"]
│   └── (references aws_iam_role.this)
│       └── Permits write to:
│           ├── s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb/*
│           └── s3:::stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz/*
│
└── aws_iam_role_policy_attachment.this["arn:aws:iam::aws:policy/AWSXrayFullAccess"]
    └── (references aws_iam_role.this)
        └── Attaches managed policy:
            └── arn:aws:iam::aws:policy/AWSXrayFullAccess

module.sfn-state-machine["csv-processor-state-machine"]
│
└── aws_sfn_state_machine.this (CSVProcessorStateMachine-Nq3DuFE2gSiF)
    ├── (role_arn references) → module.iam-role["csv-processor-sfn-role"].aws_iam_role.this
    │
    └── (definition integrates with)
        ├── GenerateCSV task → invokes Lambda (CSVGeneratorFunction)
        ├── Shipping File Analysis distributed-map
        │   ├── Item reader → s3:::stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb/shipping_data.csv (CSV format)
        │   ├── DetectDelayedOrders task → invokes Lambda (DelayedOrderDetectorFunc)
        │   ├── ProcessDelayedOrders inline-map → iterates delayed orders
        │   │   └── SendDelayedOrder task → sends to SQS queue
        │   └── Result writer → s3:::stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz/results/
        │
        └── Logging configuration
            └── CloudWatch log group: /aws/vendedlogs/states/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb (ERROR level)
```

---

## 8. Notable Decisions & Caveats

### Chomp() on State Machine Definition

The `definition` attribute in `modules/sfn-state-machine/main.tf` applies the `chomp()` function:

```hcl
definition = chomp(var.definition)
```

**Reason:** HCL heredoc string syntax (`<<EOT...EOT`) appends a trailing newline to the string value. The AWS Step Functions API stores the definition without a trailing newline. Without `chomp()`, Terraform detects a whitespace-only diff on every plan (marked as "whitespace changes" but still triggers a change). This function strips the trailing newline so the Terraform-managed value matches the cloud state exactly, avoiding spurious diffs.

### Tags Omitted

- **IAM role tags:** Discovery data showed no tags (`tags = {}`). To match cloud state exactly, the tfvars omits the tags entry, allowing the module default (`{}`) to be used.
- **State machine tags:** Discovery data includes CloudFormation-managed tags (`aws:cloudformation:stack-name`, `aws:cloudformation:logical-id`, `aws:cloudformation:stack-id`), but the Step Functions API does not return these tags to Terraform after import. State shows `tags = {}`. The tfvars omits tags to match this behavior.

### Dynamic Logging Configuration

The state machine module uses a `dynamic "logging_configuration"` block:

```hcl
dynamic "logging_configuration" {
  for_each = var.logging_configuration != null ? [var.logging_configuration] : []
  content { ... }
}
```

**Reason:** The `logging_configuration` block is optional in the Terraform provider. When set to `null`, the dynamic block evaluates to an empty list, and the logging block is omitted from the resource definition. This avoids unnecessary drift detection if logging is disabled in the future.

### Module Naming

All module instances use kebab-case keys (`csv-processor-sfn-role`, `csv-processor-state-machine`) rather than snake_case, per the handoff instructions. This ensures stable, human-readable identifiers across environment files.

### No Computed Attributes in State

The Terraform code does not define any computed-only attributes (e.g., role creation time, state machine creation date). These are managed by AWS and stored in state but are not referenced in the code or tfvars, keeping configuration compact and focused on intent.

### Resources Not Managed

The following cloud resources are referenced but **not managed** by this Terraform code (created elsewhere or pre-existing):

- Lambda functions:
  - `StepFunctionsSample-Distribut-CSVGeneratorFunction-IhOsmqsm7bTk`
  - `StepFunctionsSample-Distr-DelayedOrderDetectorFunc-Ehw2w36vxu7i`
- S3 buckets:
  - `stepfunctionssample-distributedmapcsvi-inputbucket-3c3ssp48qtjb` (input data)
  - `stepfunctionssample-distributedmapcsv-resultbucket-w0fjtmpvaezz` (output results)
- SQS queue:
  - `StepFunctionsSample-DistributedMapCSVIterator-801-DelayedOrderQueue-uaiUtI359TU8` (delayed orders)
- CloudWatch log group:
  - `/aws/vendedlogs/states/StepFunctionsSample-DistributedMapCSVIterator-801eb477-a4cb-4b2b-bfdb-c47e923731cb`

These are dependencies of the managed infrastructure and must exist before state machine executions.

### Reconciliation Status

**Final reconciliation result:** No changes. Infrastructure matches the configuration (0/0/0). All discovered resources have been imported into Terraform state with exact value fidelity.
