output "lambda_user_management_name" {
  value = aws_lambda_function.lambda_user_management.function_name
}

output "lambda_user_management_arn" {
  value = aws_lambda_function.lambda_user_management.arn
}

output "lambda_user_management_invoke_arn" {
  value = aws_lambda_function.lambda_user_management.invoke_arn
}

output "lambda_site_management_name" {
  value = aws_lambda_function.lambda_site_management.function_name
}

output "lambda_site_management_arn" {
  value = aws_lambda_function.lambda_site_management.arn
}

output "lambda_site_management_invoke_arn" {
  value = aws_lambda_function.lambda_site_management.invoke_arn
}