output "email" {
  # This may seem redundant with the `name` input, but it serves an important

  description = "The email address of the custom service account."
  value       = google_service_account.service_account.email
}