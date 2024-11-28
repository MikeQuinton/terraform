# Specifying the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

/* Static Website */

data "aws_iam_policy_document" "bucket_public_policy" {
  statement {

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_website.arn}/*"]
  }
}

resource "aws_s3_bucket" "bucket_website" {
  bucket = "michaelswebsiteterraform2024"

}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.bucket_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket_website.id

  policy = data.aws_iam_policy_document.bucket_public_policy.json
}

resource "aws_s3_object" "website_html" {
  bucket = aws_s3_bucket.bucket_website.id

  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  source_hash  = filemd5("index.html")
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.bucket_website.id

  index_document {
    suffix = "index.html"
  }
}