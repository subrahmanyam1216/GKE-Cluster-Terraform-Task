variable "project" {
  description = "The name of the GCP Project "
  type        = string
}

variable "name" {
  description = "The name of the custom service account. "
  type        = string
}


variable "description" {
  description = "The description of the custom service account."
  type        = string
  default     = ""
}

variable "service_account_roles" {
  description = "Additional roles to be added to the service account."
  type        = list(string)
  default     = []
}