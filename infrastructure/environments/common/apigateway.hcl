locals {
  _env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_vars     = local._env_vars.locals
  _region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region_vars  = local._region_vars.locals
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/apigateway"
}

dependency "authorizer" {
  config_path = "${get_terragrunt_dir()}/../authorizer"
  mock_outputs = {
    lambda_authorizer_invoke_arn = "arn:aws:lambda:us-west-2:123456789012:function:authorizer"
  }
  mock_outputs_merge_strategy_with_state = "deep_map_only"
}

dependency "lambda" {
  config_path = "${get_terragrunt_dir()}/../lambda"
  mock_outputs = {
    lambda_user_management_invoke_arn = "arn:aws:lambda:us-west-2:123456789012:function:user-management"
    lambda_site_management_invoke_arn = "arn:aws:lambda:us-west-2:123456789012:function:site-management"
  }
  mock_outputs_merge_strategy_with_state = "deep_map_only"
}

inputs = {
  region        = local.region_vars.aws_region
  stage         = local.env_vars.environment
  lambda_authorizer_invoke_arn = dependency.authorizer.outputs.lambda_authorizer_invoke_arn
  lambda_user_management_integration_arn       = dependency.lambda.outputs.lambda_user_management_invoke_arn
  lambda_site_management_integration_arn       = dependency.lambda.outputs.lambda_site_management_invoke_arn
  lambda_authorizer_arn = dependency.authorizer.outputs.lambda_authorizer_arn
  lambda_user_management_arn       = dependency.lambda.outputs.lambda_user_management_arn
  lambda_site_management_arn       = dependency.lambda.outputs.lambda_site_management_arn
}