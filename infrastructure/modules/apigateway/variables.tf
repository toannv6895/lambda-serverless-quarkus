variable "region" {
  description = "Region where the API Gateway will be deployed"
}

variable "stage" {
  description = "Stage of the API Gateway"
}

variable "lambda_authorizer_invoke_arn" {
  type = string
  description = "Invoke ARN of the Lambda Authorizer Management"
}

variable "lambda_user_management_integration_arn" {
  type = string
  description = "Invoke ARN of the Lambda User Management Integration"
}

variable "lambda_site_management_integration_arn" {
  type = string
  description = "Invoke ARN of the Lambda Site Management Integration"
}

variable "lambda_authorizer_arn" {
  type = string
  description = "ARN of the Lambda Authorizer Management"
}

variable "lambda_user_management_arn" {
  type = string
  description = "ARN of the Lambda User Management"
}

variable "lambda_site_management_arn" {
  type = string
  description = "ARN of the Lambda Site Management"
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  default     = "tf-api-gateway"
}

variable "api_gateway_type" {
  description = "Type of the API Gateway"
  default     = "HTTP"
}

variable "api_gateway_version" {
  description = "Version of the API Gateway"
  default     = "1.0"
}

variable "lambda_authorizer_name" {
  type = string
  description = "Name of the Lambda Authorizer Management"
  default     = "lambda-authorizer"
}

variable "api_stage_name" {
  type = string
  description = "Name of the API Gateway Stage"
  default     = "$default"
}

variable "api_lambda_principal" {
  type = string
  description = "Principal of the API Gateway"
  default     = "apigateway.amazonaws.com"
}

variable "api_lambda_action" {
  type = string
  description = "Principal of the API Gateway"
  default     = "lambda:InvokeFunction"
}

