resource "aws_apigatewayv2_api" "main_apigateway" {
  api_key_selection_expression = "$request.header.x-api-key"
  body                         = null
  credentials_arn              = null
  description                  = null
  disable_execute_api_endpoint = false
  fail_on_warnings             = null
  name                         = var.api_gateway_name
  protocol_type                = var.api_gateway_type
  route_key                    = null
  route_selection_expression   = "$request.method $request.path"
  target  = null
  version = var.api_gateway_version
}

resource "aws_apigatewayv2_authorizer" "api_authorizer" {
  api_id                            = main_apigateway.id
  authorizer_credentials_arn        = null
  authorizer_payload_format_version = var.api_gateway_version
  authorizer_result_ttl_in_seconds  = 300
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = var.lambda_authorizer_invoke_arn
  enable_simple_responses           = false
  identity_sources                  = ["$request.header.Authorization"]
  name                              = var.lambda_authorizer_name
}

resource "aws_apigatewayv2_integration" "user_management_integration" {
  api_id                        = main_apigateway.id
  connection_id                 = null
  connection_type               = "INTERNET"
  content_handling_strategy     = null
  credentials_arn               = null
  description                   = null
  integration_method            = "POST"
  integration_subtype           = null
  integration_type              = "AWS_PROXY"
  integration_uri               = var.lambda_user_management_integration_arn
  passthrough_behavior          = null
  payload_format_version        = "2.0"
  request_parameters            = {}
  request_templates             = {}
  template_selection_expression = null
  timeout_milliseconds          = 30000
}

resource "aws_apigatewayv2_integration" "site_management_integration" {
  api_id                        = main_apigateway.id
  connection_id                 = null
  connection_type               = "INTERNET"
  content_handling_strategy     = null
  credentials_arn               = null
  description                   = null
  integration_method            = "POST"
  integration_subtype           = null
  integration_type              = "AWS_PROXY"
  integration_uri               = var.lambda_site_management_integration_arn
  passthrough_behavior          = null
  payload_format_version        = "2.0"
  request_parameters            = {}
  request_templates             = {}
  template_selection_expression = null
  timeout_milliseconds          = 30000
}

resource "aws_apigatewayv2_deployment" "api_deployment" {
  api_id      = main_apigateway.id
  description = "Automatic deployment triggered by changes to the Api configuration"
  triggers    = null
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id                = main_apigateway.id
  auto_deploy           = true
  client_certificate_id = null
  deployment_id         = api_deployment.id
  description           = null
  name                  = var.api_stage_name
  stage_variables       = {}
  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = true
    logging_level            = null
    throttling_burst_limit   = 0
    throttling_rate_limit    = 0
  }
}
