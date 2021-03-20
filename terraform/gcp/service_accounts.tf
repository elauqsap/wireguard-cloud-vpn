resource "google_service_account" "wireguard" {
  account_id   = "wireguard"
  display_name = "wireguard"
  description  = "Service Account for the wireguard vpn instances."
  project      = module.wireguard.project_id
}