locals {
  _env_vars                = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_vars                 = local._env_vars.locals
  stage                    = local.env_vars.environment
  default_cognito_name     = "cognito-user-management"
  default_groups           = ["SUPER_ADMIN", "ADMIN", "USER"]
}

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/environments/common/cognito.hcl"
}

inputs = {
  stage                            = local.stage
  groups                           = local.default_groups
  user_pool_name                   = "${local.default_cognito_name}-${local.env_vars.environment}"
}