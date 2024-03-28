locals {
  _env_vars                = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_vars                 = local._env_vars.locals
  stage                    = local.env_vars.environment
  s3_bucket_name           = "lambda-token-access-authorizer-${local.stage}"
}

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/environments/common/s3.hcl"
}

inputs = {
  stage                            = local.stage
  s3_bucket_name                   = local.s3_bucket_name
}