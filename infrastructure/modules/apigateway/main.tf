locals {
  lambda_authorizer_full_name = "${var.lambda_authorizer_name}-${var.stage}"
  api_gateway_full_name = "${var.api_gateway_name}-${var.stage}"
}

resource "aws_apigatewayv2_api" "main_apigateway" {
  api_key_selection_expression = "$request.header.x-api-key"
  body                         = null
  credentials_arn              = null
  description                  = null
  disable_execute_api_endpoint = false
  fail_on_warnings             = null
  name                         = local.api_gateway_full_name
  protocol_type                = var.api_gateway_type
  route_key                    = null
  route_selection_expression   = "$request.method $request.path"
  target  = null
  version = var.api_gateway_version
}

resource "aws_apigatewayv2_authorizer" "api_authorizer" {
  api_id                            = aws_apigatewayv2_api.main_apigateway.id
  authorizer_credentials_arn        = null
  authorizer_payload_format_version = var.api_gateway_version
  authorizer_result_ttl_in_seconds  = 300
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = var.lambda_authorizer_invoke_arn
  enable_simple_responses           = false
  identity_sources                  = ["$request.header.Authorization"]
  name                              = local.lambda_authorizer_full_name
  depends_on = [ aws_apigatewayv2_api.main_apigateway ]
}

resource "aws_apigatewayv2_integration" "user_management_integration" {
  api_id                        = aws_apigatewayv2_api.main_apigateway.id
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
  depends_on = [ aws_apigatewayv2_api.main_apigateway ]
}

resource "aws_apigatewayv2_route" "user_management_route" {
  api_id    = aws_apigatewayv2_api.main_apigateway.id
  route_key = "ANY /users"
  target = "integrations/${aws_apigatewayv2_integration.user_management_integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id = aws_apigatewayv2_authorizer.api_authorizer.id
  depends_on = [ aws_apigatewayv2_integration.user_management_integration, aws_apigatewayv2_authorizer.api_authorizer ]
}

resource "aws_lambda_permission" "add_lambda_user_trigger_to_api_gateway" {
  action        = var.api_lambda_action
  function_name = var.lambda_user_management_arn
  principal     = var.api_lambda_principal
  source_arn    = "${aws_apigatewayv2_api.main_apigateway.execution_arn}/*/*/users"
  depends_on = [ aws_apigatewayv2_api.main_apigateway ]
}

resource "aws_apigatewayv2_integration" "site_management_integration" {
  api_id                        = aws_apigatewayv2_api.main_apigateway.id
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
  depends_on = [ aws_apigatewayv2_api.main_apigateway ]
}

resource "aws_apigatewayv2_route" "site_management_route" {
  api_id    = aws_apigatewayv2_api.main_apigateway.id
  route_key = "ANY /sites"
  target = "integrations/${aws_apigatewayv2_integration.site_management_integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id = aws_apigatewayv2_authorizer.api_authorizer.id
  depends_on = [ aws_apigatewayv2_integration.site_management_integration, aws_apigatewayv2_authorizer.api_authorizer ]
}

# resource "aws_apigatewayv2_route" "api_route" {
#   api_id    = aws_apigatewayv2_api.main_apigateway.id
#   route_key = "$default"
# }

resource "aws_lambda_permission" "add_lambda_site_trigger_to_api_gateway" {
  action        = var.api_lambda_action
  function_name = var.lambda_site_management_arn
  principal     = var.api_lambda_principal
  source_arn    = "${aws_apigatewayv2_api.main_apigateway.execution_arn}/*/*/sites"
  depends_on = [ aws_apigatewayv2_api.main_apigateway ]
}


resource "aws_apigatewayv2_deployment" "api_deployment" {
  api_id      = aws_apigatewayv2_api.main_apigateway.id
  description = "Automatic deployment triggered by changes to the Api configuration"
  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.user_management_integration),
      jsonencode(aws_apigatewayv2_route.user_management_route),
      jsonencode(aws_apigatewayv2_integration.site_management_integration),
      jsonencode(aws_apigatewayv2_route.site_management_route),
    ])))
  }
  depends_on = [ aws_apigatewayv2_route.user_management_route, aws_apigatewayv2_route.site_management_route ]
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id                = aws_apigatewayv2_api.main_apigateway.id
  auto_deploy           = true
  client_certificate_id = null
  deployment_id         = aws_apigatewayv2_deployment.api_deployment.id
  description           = null
  name                  = var.api_stage_name
  stage_variables       = {}
  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = true
    logging_level            = null
    throttling_burst_limit   = 5000
    throttling_rate_limit    = 10000
  }
}
