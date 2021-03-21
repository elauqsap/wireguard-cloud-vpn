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

# --------------------------------------------------
# Instance Template: Optional Parameters
# --------------------------------------------------
variable "machine_type" {
  description = "Machine type for compute instance"
  type        = string
  default     = "g1-small"
}

variable "boot_disk_image_family" {
  description = "Image family to use with boot disk"
  type        = string
  default     = "debian-10"
}

variable "boot_disk_image_project" {
  description = "Project hosting the images"
  type        = string
  default     = "debian-cloud"
}

variable "boot_disk_size_gb" {
  description = "Size (in GB) for the boot disk"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Type of disk to use for boot"
  type        = string
  default     = "pd-ssd"
}

variable "boot_disk_auto_delete" {
  description = "Auto-delete boot disk on destruction"
  type        = bool
  default     = true
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, i.e. NAT instances"
  type        = bool
  default     = true
}

variable "instance_labels" {
  description = "Common labels to apply to instances"
  type        = map(any)
  default = {
    env       = "production"
    vpn       = true
    exit_node = true
  }
}

variable "instance_tags" {
  description = "Network tags, provided as a list"
  type        = list(string)
  default = [
    "iap-ssh"
  ]
}

variable "service_account_scopes" {
  description = "A list of service scopes for a service account"
  type        = list(any)
  default = [
    "cloud-platform"
  ]
}

variable "metadata" {
  description = "Metadata configuration for instances"
  type        = map(string)
  default = {
    enable-oslogin = "TRUE"
  }
}