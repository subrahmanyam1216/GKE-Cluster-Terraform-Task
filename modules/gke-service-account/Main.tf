
# Create service_account

resource "google_service_account" "service_account" {
  project      = var.project
  account_id   = var.name
  #account_id   = "serviceaccount"
  display_name = var.description
}




locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
}

resource "google_project_iam_member" "service_account-roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
