# Check s3 bucket is exists or not
data "external" "s3_bucket-exists" {
  program = ["bash", "${path.module}/script/s3_bucket-exists.sh"]

  query = {
    bucket_name = var.s3_bucket_name
  }
}

data "aws_s3_bucket" "data-user-management-bucket" {
  count = data.external.s3_bucket-exists.result.exists == "true" ? 1 : 0
  bucket = var.s3_bucket_name
}

# Create S3 bucket
resource "aws_s3_bucket" "user-management-bucket" {
  count = data.external.s3_bucket-exists.result.exists == "true" ? 0 : 1
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_public_access_block" "user-management-bucket-public-access" {
  count = length(aws_s3_bucket.user-management-bucket) != 0 ? 1 : 0
  bucket = aws_s3_bucket.user-management-bucket[count.index].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  depends_on              = [aws_s3_bucket.user-management-bucket]
}

data "template_file" "user-management-policy-template" {
  count = length(aws_s3_bucket.user-management-bucket) != 0 ? 1 : 0
  template = file("${path.module}/template/s3-policy.json.tpl")

  vars = {
    arn = "${aws_s3_bucket.user-management-bucket[count.index].arn}"
  }
  depends_on              = [aws_s3_bucket.user-management-bucket]
}

resource "aws_s3_bucket_policy" "allow_access_s3" {
  count = length(aws_s3_bucket.user-management-bucket) != 0 ? 1 : 0
  bucket = aws_s3_bucket.user-management-bucket[count.index].id
  policy = data.template_file.user-management-policy-template[count.index].rendered
  depends_on              = [aws_s3_bucket.user-management-bucket]
}

resource "aws_s3_object" "user-management-object" {
  count = length(aws_s3_bucket.user-management-bucket) + length(data.aws_s3_bucket.data-user-management-bucket)
  key    = "/${var.stage}/"
  bucket = length(aws_s3_bucket.user-management-bucket) != 0 ? aws_s3_bucket.user-management-bucket[count.index].id : data.aws_s3_bucket.data-user-management-bucket[count.index].id
  content_type = "application/x-directory"
}