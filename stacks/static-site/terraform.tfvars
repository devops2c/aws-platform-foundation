bucket_name            = "mystaticwebsite2036"
enable_versioning      = true
enable_encryption      = true
force_destroy          = false
public_access_block    = false
website_index_document = "index.html"
website_error_document = "error.html"
tags = {
  Environment = "dev"
  Project     = "static-site"
  Owner       = "Mohamed B."
}
