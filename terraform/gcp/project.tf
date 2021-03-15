locals {
  project_suffix = split(format("%s-", var.project_name), module.wireguard.project_id)[1]
}

module "wireguard" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.2.1"

  name                    = var.project_name
  org_id                  = var.org_id
  billing_account         = var.billing_account
  project_id              = var.project_id
  random_project_id       = true
  default_service_account = "delete"
  labels                  = var.labels

  activate_apis = [
    "cloudbilling.googleapis.com",
  ]

  # budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]
  # budget_amount               = 100
}