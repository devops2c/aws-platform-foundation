resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy

  # Versioning
  versioning {
    enabled = var.enable_versioning
  }

  # Encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.enable_encryption ? "AES256" : null
      }
    }
  }

  # Public access block
  block_public_acls   = var.public_access_block
  block_public_policy = var.public_access_block
  ignore_public_acls  = var.public_access_block
  restrict_public_buckets = var.public_access_block

  # Website configuration
  website {
    index_document = var.website_index_document
    error_document = var.website_error_document
  }

  tags = var.tags
}