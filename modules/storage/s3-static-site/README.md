# Module: s3-static-site

This module creates an AWS S3 bucket for hosting a static website.

## Variables

- `bucket_name` (string) – required
- `enable_versioning` (bool) – default: true
- `enable_encryption` (bool) – default: true
- `force_destroy` (bool) – default: false
- `public_access_block` (bool) – default: true
- `website_index_document` (string) – default: index.html
- `website_error_document` (string) – default: error.html
- `tags` (map(string)) – default: {}

## Outputs

- `bucket_name`
- `bucket_arn`
- `website_endpoint`