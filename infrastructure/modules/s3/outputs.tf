output "s3_authorizer_bucket" {
  value = aws_s3_object.user-management-object[0].key
}