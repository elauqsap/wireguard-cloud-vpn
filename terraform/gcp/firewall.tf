# --------------------------------------------------
# OUTBOUND: Allow
# --------------------------------------------------

# --------------------------------------------------
# OUTBOUND: Deny
# --------------------------------------------------

# --------------------------------------------------
# INBOUND: Allow
# --------------------------------------------------
resource "google_compute_firewall" "allow_iap_ssh_tag" {
  name    = "allow-iap-ssh-tag"
  network = module.vpn.network_self_link
  project = module.wireguard.project_id

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
  source_ranges = ["35.235.240.0/20"]

  target_tags = [
    "iap-ssh",
  ]
}


# --------------------------------------------------
# INBOUND: Deny
# --------------------------------------------------