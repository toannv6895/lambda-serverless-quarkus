locals {
  _env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_vars     = local._env_vars.locals
  _region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region_vars  = local._region_vars.locals
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/authorizer"
}

dependency "cognito" {
  config_path = "${get_terragrunt_dir()}/../cognito"
  mock_outputs = {
    user_pool_id = "user-management-us-east-1_123456789"
    user_pool_client_id = "123456789"
    user_pool_arn = "arn:aws:cognito-idp:us-east-1:478683517286:userpool/test"
  }
  mock_outputs_merge_strategy_with_state = "deep_map_only"
}

dependency "s3" {
  config_path = "${get_terragrunt_dir()}/../s3"
  mock_outputs = {
    s3_authorizer_bucket = "user-management-authorizer-bucket"
  }
  mock_outputs_merge_strategy_with_state = "deep_map_only"
}

inputs = {
  region        = local.region_vars.aws_region
  stage         = local.env_vars.environment
  user_pool_id = dependency.cognito.outputs.user_pool_id
  user_pool_client_id = dependency.cognito.outputs.user_pool_client_id
  s3_authorizer_bucket = dependency.s3.outputs.s3_authorizer_bucket
}