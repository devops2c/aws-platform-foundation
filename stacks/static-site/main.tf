module "s3_static_site" {
  source = "../../modules/storage/s3-static-site"
#syntaxe var.bucket_name cad ==> Source de la valeur : fichier terraform.tfvars local du stack (ou via CLI -var)
  bucket_name             = var.bucket_name
  enable_versioning       = var.enable_versioning
  enable_encryption       = var.enable_encryption
  force_destroy           = var.force_destroy
  public_access_block     = var.public_access_block
  website_index_document  = var.website_index_document
  website_error_document  = var.website_error_document
  tags                    = var.tags
}