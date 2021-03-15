# --------------------------------------------------
# REQUIRED PARAMETERS
# --------------------------------------------------
variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}

variable "org_id" {
  description = "The organization ID (can be blank)"
  type        = string
}

# --------------------------------------------------
# Project: Optional Parameters
# --------------------------------------------------
variable "project_name" {
  description = "Project name to use"
  type        = string
  default     = "wireguard-cloud-vpn"
}

variable "project_id" {
  description = "Project ID prefix to use"
  type        = string
  default     = "wireguard-cloud-vpn"
}

variable "labels" {
  description = "Common labels to apply"
  type        = map(any)
  default     = {}
}

# --------------------------------------------------
# Bucket: Optional Parameters
# --------------------------------------------------
variable "bucket_name" {
  description = "Bucket name for git operations"
  type        = string
  default     = "gitops"
}

variable "bucket_location" {
  description = "Region for the Bucket objects to be stored"
  type        = string
  default     = "US"
}

variable "bucket_storage_class" {
  description = "Storage Class for the Bucket"
  type        = string
  default     = "MULTI_REGIONAL"
}

# --------------------------------------------------
# VPN: Optional Parameters
# --------------------------------------------------
variable "subnet_flow_logs" {
  type = object({
    enabled  = bool
    interval = string
    sampling = number
    metadata = string
  })
  default = {
    enabled  = false
    interval = "INTERVAL_30_SEC"
    sampling = 0.8
    metadata = "INCLUDE_ALL_METADATA"
  }
}