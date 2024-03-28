output "user_pool_arn" {
  value = aws_cognito_user_pool.user-pool.arn
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user-pool.id
}

output "aws_cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.cognito-portal-client.id
}