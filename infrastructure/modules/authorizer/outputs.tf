output "lambda_authorizer_name" {
  value = aws_lambda_function.lambda-authorizer.function_name
}

output "lambda_authorizer_arn" {
  value = aws_lambda_function.lambda-authorizer.arn
}

output "lambda_authorizer_invoke_arn" {
  value = aws_lambda_function.lambda-authorizer.invoke_arn
}