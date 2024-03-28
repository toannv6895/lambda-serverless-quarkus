data "local_file" "file_user_management" {
  filename = "${path.root}/../src/user-management/target/function.zip"
}

resource "aws_lambda_function" "lambda_user_management" {
  architectures                  = var.lambda_service_architecture
  code_signing_config_arn        = null
  description                    = null
  filename                       = data.local_file.file_user_management.filename
  function_name                  = var.lambda_user_management_name
  handler                        = var.lambda_quarkus_handler
  image_uri                      = null
  kms_key_arn                    = null
  layers                         = []
  memory_size                    = 512
  package_type                   = var.lambda_service_package_type
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = var.lambda_role
  runtime                        = var.lambda_service_runtime
  s3_bucket                      = null
  s3_key                         = null
  s3_object_version              = null
  skip_destroy                   = false
  source_code_hash               = data.alocal_file.file_user_management.output_base64sha256
  tags                           = {}
  tags_all                       = {}
  timeout                        = 15
  ephemeral_storage {
    size = 512
  }
  logging_config {
    application_log_level = var.lambda_service_log_level
    log_format            = var.lambda_service_log_format
    log_group             = "/aws/lambda/${var.lambda_user_management_name}"
    system_log_level      = null
  }
  tracing_config {
    mode = var.lambda_service_trace_mode
  }
}

data "local_file" "file_site_management" {
  filename = "${path.root}/../src/site-management/target/function.zip"
}


resource "aws_lambda_function" "lambda_site_management" {
  architectures                  = var.lambda_service_architecture
  code_signing_config_arn        = null
  description                    = null
  filename                       = data.local_file.file_site_management.filename
  function_name                  = var.lambda_site_management_name
  handler                        = var.lambda_quarkus_handler
  image_uri                      = null
  kms_key_arn                    = null
  layers                         = []
  memory_size                    = 512
  package_type                   = var.lambda_service_package_type
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = var.lambda_role
  runtime                        = var.lambda_service_runtime
  s3_bucket                      = null
  s3_key                         = null
  s3_object_version              = null
  skip_destroy                   = false
  source_code_hash               = data.archive_file.archive_file_site_management.output_base64sha256
  tags                           = {}
  tags_all                       = {}
  timeout                        = 15
  ephemeral_storage {
    size = 512
  }
  logging_config {
    application_log_level = var.lambda_service_log_level
    log_format            = var.lambda_service_log_format
    log_group             = "/aws/lambda/${var.lambda_site_management_name}"
    system_log_level      = null
  }
  tracing_config {
    mode = var.lambda_service_trace_mode
  }
}
