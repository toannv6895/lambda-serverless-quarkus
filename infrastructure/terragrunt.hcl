locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region_vars.locals.aws_region}"
    default_tags {
    tags = {
        Environment = "${local.environment_vars.locals.environment}"
        ManageBy        = "Terraform"
      }
    }
  }
  EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "abs-backend-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region_vars.locals.aws_region
    dynamodb_table = "abs-backend-terraform-state-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals,
)