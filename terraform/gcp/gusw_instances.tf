locals {
  gusw_distribution = {
    "us-west1" = [
      {
        zone       = "us-west1-a"
        network_ip = "10.0.0.2"
      }
    ]
  }
}

module "gusw_tpl" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 6.2"

  name_prefix  = "vpn"
  project_id   = module.wireguard.project_id
  machine_type = var.machine_type
  metadata     = var.metadata
  labels       = var.instance_labels
  tags         = var.instance_tags

  /* service account */
  service_account = {
    email  = google_service_account.wireguard.email
    scopes = var.service_account_scopes
  }

  /* image */
  source_image_family  = var.boot_disk_image_family
  source_image_project = var.boot_disk_image_project

  /* disks */
  disk_size_gb = var.boot_disk_size_gb
  disk_type    = var.boot_disk_type
  auto_delete  = var.boot_disk_auto_delete

  /* network */
  subnetwork         = local.vpn_links_by_name["gusw1-wg"]
  subnetwork_project = module.wireguard.project_id
  can_ip_forward     = var.can_ip_forward
}

resource "google_compute_instance_from_template" "gusw1_instances" {
  provider = google
  count    = length(local.gusw_distribution["us-west1"])

  name    = "vpn-gusw1-${format("%03d", count.index + 1)}"
  project = module.wireguard.project_id
  zone    = local.gusw_distribution["us-west1"][count.index].zone


  network_interface {
    network            = module.vpn.network_self_link
    network_ip         = local.gusw_distribution["us-west1"][count.index].network_ip
    subnetwork         = local.vpn_links_by_name["gusw1-wg"]
    subnetwork_project = module.wireguard.project_id
  }

  source_instance_template = module.gusw_tpl.self_link
}