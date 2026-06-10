# Root module — wires variable maps into child modules.
# No bare resource blocks here; all resources live inside modules/.

# ── IAM Roles ─────────────────────────────────────────────────────────────────
module "iam-role" {
  source   = "./modules/iam-role"
  for_each = var.iam_roles

  name                 = each.value.name
  path                 = each.value.path
  description          = each.value.description
  assume_role_policy   = each.value.assume_role_policy
  max_session_duration = each.value.max_session_duration
  permissions_boundary = each.value.permissions_boundary
  tags                 = each.value.tags
  inline_policies      = each.value.inline_policies
  managed_policy_arns  = each.value.managed_policy_arns
}

# ── Step Functions State Machines ──────────────────────────────────────────────
module "sfn-state-machine" {
  source   = "./modules/sfn-state-machine"
  for_each = var.sfn_state_machines

  name                  = each.value.name
  role_arn              = each.value.role_arn
  definition            = each.value.definition
  type                  = each.value.type
  tags                  = each.value.tags
  logging_configuration = each.value.logging_configuration
  tracing_enabled       = each.value.tracing_enabled
}
