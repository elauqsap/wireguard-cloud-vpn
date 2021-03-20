locals {
  network_name = "wg"

  wireguard_subnets = [
    {
      subnet_name               = "gusw1-${local.network_name}"
      subnet_ip                 = "10.0.0.0/29"
      subnet_region             = "us-west1"
      subnet_private_access     = "true"
      subnet_flow_logs          = var.subnet_flow_logs.enabled
      subnet_flow_logs_interval = var.subnet_flow_logs.interval
      subnet_flow_logs_sampling = var.subnet_flow_logs.sampling
      subnet_flow_logs_metadata = var.subnet_flow_logs.metadata
    },
    {
      subnet_name               = "gusw2-${local.network_name}"
      subnet_ip                 = "10.0.0.8/29"
      subnet_region             = "us-west2"
      subnet_private_access     = "true"
      subnet_flow_logs          = var.subnet_flow_logs.enabled
      subnet_flow_logs_interval = var.subnet_flow_logs.interval
      subnet_flow_logs_sampling = var.subnet_flow_logs.sampling
      subnet_flow_logs_metadata = var.subnet_flow_logs.metadata
    },
    {
      subnet_name               = "gusw3-${local.network_name}"
      subnet_ip                 = "10.0.0.16/29"
      subnet_region             = "us-west3"
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

  project_id   = module.wireguard.project_id
  network_name = local.network_name
  subnets      = local.wireguard_subnets
}

# ----------------------------------------------------
# Cloud Routers w/ NAT per subnet region
# ----------------------------------------------------
module "gusw1_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"

  name    = "${local.network_name}-router-gusw1"
  project = module.wireguard.project_id
  region  = "us-west1"
  network = module.vpn.network_name

  nats = [{
    name = "${local.network_name}-nat-gusw1"
  }]
}