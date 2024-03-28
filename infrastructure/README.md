# AESI infrastructure

## Tech stack
- Terraform
- Terragrunt
- Ansible

## Description
This project use to create infra for backend consist of: Cognito (user management), lambda (site, site configuration, customer, monitoring), s3 (site-configuration), api gateway.

## How to run it as a developer
### Prerequisites
- Terraform, Terragrunt and Ansible installed on your local machine
- AWS account credentials

### Getting Started as developer
1. Select working directory environment which you want
2. Plan the infrastructure changes: `terragrunt run-all plan -input=false --out tfplan.out`
3. Apply the infrastructure changes: `terragrunt run-all apply --terragrunt-non-interactive`

### Cleaning Up
To destroy the provisioned infrastructure and clean up resources, run the following command:
`terragrunt run-all destroy --terragrunt-non-interactive`

## How to run it through gitlab pipeline
1. go to Build > Pipelines > Run pipeline
![Run pipeline](images/run_pipeline.png)

2. Input parameters
- ENVIRONMENT_CI (default is `commit ref slug`)
- REGION_CI (default is `us-east-1`)
- Example: I want to deploy a new environment with name `test` for `us-east-2` region
![Input parameters](images/input_parameters.png)

3. Run a job what you want
![Run job](images/run_job.png)