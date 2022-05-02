output endpoint {
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}
output bucket_name {
  value       = aws_s3_bucket.website.id
}
output bucket_regional_domain_name {
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}
