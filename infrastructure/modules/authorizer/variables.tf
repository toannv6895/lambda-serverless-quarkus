variable "region" {
  type        = string
  description = "AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "stage" {
  type        = string
  description = "stage of the environment"
  default     = "test"
}

variable "user_pool_id" {
  type        = string
  description = "Cognito user pool id"
}

variable "user_pool_client_id" {
  type        = string
  description = "Cognito user pool client id"
}

variable "s3_authorizer_bucket" {
  type        = string
  description = "S3 bucket name to store the lambda function"
}

variable "app_log" {
  type        = string
  description = "Log group name for the lambda function"
  default     = "access-token-author"
}

variable "lambda_role" {
  type        = string
  description = "Lambda execution role"
  default     = "arn:aws:iam::478683517286:role/service-role/lambda-role"
}

variable "lambda_authorizer_name" {
  type        = string
  description = "Lambda authorizer function name"
  default     = "lambda-authorizer"
}

variable "lambda_authorizer_runtime" {
  type        = string
  description = "Lambda authorizer runtime"
  default     = "provided.al2"
}

variable "lambda_authorizer_handler" {
  type        = string
  description = "Lambda authorizer handler"
  default     = "hello.handler"
}

variable "lambda_service_package_type" {
  type        = string
  description = "Lambda service package type"
  default     = "Zip"
}

variable "lambda_service_trace_mode" {
  type        = string
  description = "Lambda trace mode"
  default     = "Active"
}

variable "lambda_service_log_level" {
  type        = string
  description = "Lambda log level"
  default     = "error"
}

variable "lambda_service_log_format" {
  type        = string
  description = "Lambda log format"
  default     = "json"
}

variable "lambda_service_architecture" {
  type        = list(string)
  description = "Lambda service architecture"
  default     = ["x86_64"]
}