locals {
  geuw_distribution = {
    "europe-west1" = [
      {
        zone       = "europe-west1-b" # 	St. Ghislain, Belgium, Europe
        network_ip = "10.0.0.74"
      }
    ]
    "europe-west2" = [
      {
        zone       = "europe-west2-a" # 	London, England, Europe
        network_ip = "10.0.0.82"
      }
    ]
  }
}

module "geuw_tpl" {
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
  subnetwork         = local.vpn_links_by_name["geuw2-wg"]
  subnetwork_project = module.wireguard.project_id
  can_ip_forward     = var.can_ip_forward
}

resource "google_compute_instance_from_template" "geuw1_instances" {
  provider = google
  count    = length(local.geuw_distribution["europe-west1"])

  name    = "vpn-geuw1-${format("%03d", count.index + 1)}"
  project = module.wireguard.project_id
  zone    = local.geuw_distribution["europe-west1"][count.index].zone


  network_interface {
    network            = module.vpn.network_self_link
    network_ip         = local.geuw_distribution["europe-west1"][count.index].network_ip
    subnetwork         = local.vpn_links_by_name["geuw1-wg"]
    subnetwork_project = module.wireguard.project_id
  }

  source_instance_template = module.geuw_tpl.self_link
}

resource "google_compute_instance_from_template" "geuw2_instances" {
  provider = google
  count    = length(local.geuw_distribution["europe-west2"])

  name    = "vpn-geuw2-${format("%03d", count.index + 1)}"
  project = module.wireguard.project_id
  zone    = local.geuw_distribution["europe-west2"][count.index].zone


  network_interface {
    network            = module.vpn.network_self_link
    network_ip         = local.geuw_distribution["europe-west2"][count.index].network_ip
    subnetwork         = local.vpn_links_by_name["geuw2-wg"]
    subnetwork_project = module.wireguard.project_id
  }

  source_instance_template = module.geuw_tpl.self_link
}