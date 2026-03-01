variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable bucket encryption"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Destroy bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "public_access_block" {
  description = "Block all public access"
  type        = bool
  default     = true
}

variable "website_index_document" {
  description = "Index document for static website"
  type        = string
  default     = "index.html"
}

variable "website_error_document" {
  description = "Error document for static website"
  type        = string
  default     = "error.html"
}

variable "tags" {
  description = "Map of tags for the bucket"
  type        = map(string)
  default     = {}
}
