locals {
  lambda_authorizer_full_name = "${var.lambda_authorizer_name}-${var.stage}"
}

data "local_file" "file_authorizer" {
  filename = "${path.module}/files/access-token-authorizer.zip"
}

resource "aws_lambda_function" "lambda-authorizer" {
  architectures                  = var.lambda_service_architecture
  code_signing_config_arn        = null
  description                    = null
  filename                       = data.local_file.file_authorizer.filename
  function_name                  = local.lambda_authorizer_full_name
  handler                        = var.lambda_authorizer_handler
  image_uri                      = null
  kms_key_arn                    = null
  layers                         = []
  memory_size                    = 128
  package_type                   = var.lambda_service_package_type
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = var.lambda_role
  runtime                        = var.lambda_authorizer_runtime
  s3_bucket                      = null
  s3_key                         = null
  s3_object_version              = null
  skip_destroy                   = false
  source_code_hash               = data.local_file.file_authorizer.content_base64sha256
  tags                           = {}
  tags_all                       = {}
  timeout                        = 3
  environment {
    variables = {
      APP_LOG        = var.app_log
      CLIENT_ID      = var.user_pool_client_id
      REGION_ID      = var.region
      RUST_BACKTRACE = "1"
      S3_BUCKET      = var.s3_authorizer_bucket
      USER_POOL_ID   = var.user_pool_id
    }
  }
  ephemeral_storage {
    size = 512
  }
  logging_config {
    application_log_level = var.lambda_service_log_level
    log_format            = var.lambda_service_log_format
    log_group             = "/aws/lambda/${local.lambda_authorizer_full_name}"
    system_log_level      = null
  }
  tracing_config {
    mode = "PassThrough"
  }
}