locals {
  network_name = "wg"

  wireguard_subnets = [
    {
      subnet_name               = "gusw1-${local.network_name}"
      subnet_ip                 = "10.0.0.0/30"
      subnet_region             = "us-west1"
      subnet_private_access     = "true"
      subnet_flow_logs          = var.subnet_flow_logs.enabled
      subnet_flow_logs_interval = var.subnet_flow_logs.interval
      subnet_flow_logs_sampling = var.subnet_flow_logs.sampling
      subnet_flow_logs_metadata = var.subnet_flow_logs.metadata
    },
    {
      subnet_name               = "gusw2-${local.network_name}"
      subnet_ip                 = "10.0.0.4/30"
      subnet_region             = "us-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = var.subnet_flow_logs.enabled
      subnet_flow_logs_interval = var.subnet_flow_logs.interval
      subnet_flow_logs_sampling = var.subnet_flow_logs.sampling
      subnet_flow_logs_metadata = var.subnet_flow_logs.metadata
    },
    {
      subnet_name               = "gusw3-${local.network_name}"
      subnet_ip                 = "10.0.0.8/30"
      subnet_region             = "us-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = var.subnet_flow_logs.enabled
      subnet_flow_logs_interval = var.subnet_flow_logs.interval
      subnet_flow_logs_sampling = var.subnet_flow_logs.sampling
      subnet_flow_logs_metadata = var.subnet_flow_logs.metadata
    }
  ]
}

# ----------------------------------------------------
# Shared VPC for global VPN infrastructure
# ----------------------------------------------------
module "vpn" {
  source  = "terraform-google-modules/network/google"
  version = "3.1.2"

  project_id      = module.wireguard.project_id
  network_name    = local.network_name
  shared_vpc_host = true
  subnets         = local.wireguard_subnets
}

