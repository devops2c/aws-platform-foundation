output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3_static_site.bucket_name
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3_static_site.bucket_arn
}

output "website_endpoint" {
  description = "The website endpoint of the bucket"
  value       = module.s3_static_site.website_endpoint
}