locals {
  _env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_vars     = local._env_vars.locals
  _region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region_vars  = local._region_vars.locals
}

terraform {
  source = "${get_repo_root()}/infrastructure/modules/s3"
}

inputs = {
  region        = local.region_vars.aws_region
  stage         = local.env_vars.environment
}