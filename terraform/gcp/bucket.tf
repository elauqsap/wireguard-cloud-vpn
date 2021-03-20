resource "google_storage_bucket" "gitops" {
  project       = module.wireguard.project_id
  name          = format("%s-%s", var.bucket_name, local.project_suffix)
  location      = var.bucket_location
  storage_class = var.bucket_storage_class

  versioning {
    enabled = true
  }

  # WARNING: setting to true will cause TF to fail
  # when attempting to delete the bucket
  force_destroy = true

  # NOTE: Uniform IAM permissions to all objects in
  # the bucket when true
  uniform_bucket_level_access = true
}