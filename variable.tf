#Project variables
variable "project_defaults" {
  type = map(string)
  default = {
    "project"                                  = "processing-project-418110"
     "location"                                = "us-central1-a"
     "region"                                  = "us-central1"
     #"cluster_name"                            = "gke-ingestion-cluster"
     "cluster_service_account_description"     = "GKE Cluster Service Account managed by Terraform"
     "master_ipv4_cidr_block"                  = "10.5.0.0/28"
     "vpc_cidr_block"                          = "172.20.30.0/24"
     "vpc_secondary_cidr_block"                = "172.20.40.0/24"
     "public_subnetwork_secondary_range_name"  = "gke-cluster-secondary"
     "public_services_secondary_range_name"    = "gke-cluster-services"
     "cluster_service_account_name"            = "terraform@dev-env-406507.iam.gserviceaccount.com"
     "public_services_secondary_cidr_block"    = null
     "private_services_secondary_cidr_block"   = null
     "secondary_cidr_subnetwork_width_delta"   = 4
     "secondary_cidr_subnetwork_spacing"       = 0

     
  }

}

