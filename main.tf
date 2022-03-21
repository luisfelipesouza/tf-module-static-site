resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    application   = lower(var.application)
    cost-center   = lower(var.cost-center)
    deployed-by   = lower(var.deployed-by)
  }
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = var.index_document
  }
  error_document {
    key = var.index_document
  }
}
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}

data "aws_iam_policy_document" "website" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.website.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "DELETE", "PUT"]
    allowed_origins = ["*"]
  }
}

resource "null_resource" "upload_content" {
  provisioner "local-exec" {
    command = "aws s3 sync ${var.content_path} s3://${aws_s3_bucket.website.id}"
  }

  depends_on = [aws_s3_bucket.website]
}