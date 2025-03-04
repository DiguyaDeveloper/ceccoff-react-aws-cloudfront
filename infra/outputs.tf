output "s3_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.frontend.domain_name
}
