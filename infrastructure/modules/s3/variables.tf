variable "stage" {
  description = "The stage of the environment"
  default     = "dev"
}

variable "region" {
  description = "The region where the resources will be deployed"
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  default = "user-management-authorizer"
}