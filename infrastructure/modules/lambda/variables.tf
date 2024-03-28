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

variable "lambda_role" {
  type        = string
  description = "Lambda execution role"
  default     = "arn:aws:iam::478683517286:role/service-role/lambda-role"
}

variable "lambda_user_management_name" {
  type        = string
  description = "Lambda user management function name"
  default     = "lambda-user-management"
}

variable "lambda_site_management_name" {
  type        = string
  description = "Lambda site management function name"
  default     = "lambda-site-management"
}

variable "lambda_service_architecture" {
  type        = list(string)
  description = "Lambda service architecture"
  default     = ["x86_64"]
}

variable "lambda_service_runtime" {
  type        = string
  description = "Lambda service runtime"
  default     = "provided.al2023"
}

variable "lambda_quarkus_handler" {
  type        = string
  description = "Lambda service architecture"
  default     = "io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest"
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