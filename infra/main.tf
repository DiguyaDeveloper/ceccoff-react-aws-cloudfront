terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

variable "aws_region" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

resource "aws_s3_bucket" "react_bucket" {
  bucket = "meu-react-app-bucket"

  tags = {
    Name = "React App Bucket"
  }
}

resource "aws_s3_bucket_website_configuration" "react_bucket" {
  bucket = aws_s3_bucket.react_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.react_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.react_bucket.id}/*"
    }
  ]
}
POLICY
}

resource "aws_cloudfront_distribution" "react_distribution" {
  origin {
    domain_name = aws_s3_bucket.react_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.react_bucket.id}"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.react_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }


}

output "s3_bucket_name" {
  value = aws_s3_bucket.react_bucket.id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.react_distribution.id
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.react_distribution.domain_name
}
