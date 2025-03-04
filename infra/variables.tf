variable "aws_region" {
  description = "Região da AWS"
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3 para hospedar o frontend"
  type        = string
}

variable "cloudfront_price_class" {
  description = "Classe de preço do CloudFront (ex: PriceClass_100, PriceClass_200, PriceClass_All)"
  default     = "PriceClass_100"
}

variable "domain_name" {
  description = "Nome do domínio (opcional)"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ARN do certificado ACM para HTTPS (se for usar domínio próprio)"
  type        = string
  default     = ""
}
