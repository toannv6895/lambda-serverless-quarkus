locals {
  _env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_vars     = local._env_vars.locals
  _region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region_vars  = local._region_vars.locals
}

terraform {
  source = "${get_repo_root()}/modules//authorizer"
}

dependency "cognito" {
  config_path = "${get_terragrunt_dir()}/../cognito"
  mock_outputs = {
    user_pool_arn = "arn:aws:cognito-idp:us-east-1:478683517286:userpool/test"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs = true
}

dependency "s3" {
  config_path = "${get_terragrunt_dir()}/../s3"
  mock_outputs_merge_strategy_with_state = "shallow"
  skip_outputs = true
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../cognito", "${get_terragrunt_dir()}/../lambda"]
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../s3", "${get_terragrunt_dir()}/../s3"]
}

inputs = {
  stage = local.env_vars.environment
  region = local.region_vars.region
  user_pool_id = dependency.cognito.outputs.user_pool_id
  user_pool_client_id = dependency.cognito.outputs.user_pool_client_id
  s3_authorizer_bucket = dependency.s3.outputs.s3_authorizer_bucket
}