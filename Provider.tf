provider "google" {
  project = var.project_defaults.project
  region  = var.project_defaults.region
}

provider "google-beta" {

  project = var.project_defaults.project
  region  = var.project_defaults.region
}


resource "random_integer" "int" {
    min = 100
    max = 1000000
}


terraform {
  
  required_version = ">= 0.12.26"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.43.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.43.0"
    }
  }
}