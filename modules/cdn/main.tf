terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "storage_bucket" {
  bucket = aws_s3_bucket.storage_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "storage_bucket" {
  bucket                  = aws_s3_bucket.storage_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "storage_bucket" {
  bucket = aws_s3_bucket.storage_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "storage_bucket" {
  bucket = aws_s3_bucket.storage_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "content_network" {
  name                              = "${var.bucket_name}_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "content_network" {
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"
  aliases         = [var.fqdn_domain_name]
  origin {
    domain_name              = aws_s3_bucket.storage_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.storage_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.content_network.id
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.storage_bucket.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.aws_acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

data "aws_iam_policy_document" "content_network_access_storage_bucket" {
  statement {
    sid       = "AllowCloudFrontServicePrincipalReadWrite"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.storage_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.content_network.arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "storage_bucket" {
  bucket = aws_s3_bucket.storage_bucket.id
  policy = data.aws_iam_policy_document.content_network_access_storage_bucket.json
}

resource "cloudflare_record" "cdn_record" {
  zone_id         = var.zone_id
  allow_overwrite = true
  proxied         = false
  type            = "CNAME"
  name            = var.fqdn_domain_name
  content         = aws_cloudfront_distribution.content_network.domain_name
  ttl             = 1
  comment         = "Managed with terraform."
}

resource "aws_s3_bucket_cors_configuration" "storage_bucket" {
  bucket = aws_s3_bucket.storage_bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT"]
    allowed_origins = ["*.${var.domain_name}"]
    expose_headers  = []
    max_age_seconds = 300
  }
}
