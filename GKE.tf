module "ingestion_gke_cluster" {
  
  source = "./modules/gke-cluster"
  name                          = "ingestion_gke_cluster"
  project                       = var.project_defaults.project
  location                      = var.project_defaults.location
  network                       = module.vpc_network.network
  subnetwork                    = module.vpc_network.public_subnetwork
  cluster_secondary_range_name  = module.vpc_network.public_subnetwork_secondary_range_name
  services_secondary_range_name = module.vpc_network.public_services_secondary_range_name

  master_ipv4_cidr_block        = var.project_defaults.master_ipv4_cidr_block

  # This setting will make the cluster private
  enable_private_nodes          = "true"
  release_channel               = ""

 
  disable_public_endpoint       = "false"

  # private cluster
  
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "10.0.0.0/8"
          display_name = "private-net-gke-subnet"
        },
         {
          cidr_block   = "172.20.30.0/24"
          display_name = "private-net-gke-subnet for infosys-lan"
        },
      ]
    },
  ]

 
  #labels
  resource_labels = {
    environment = "ingestion-prod"
    
  }

# CREATE A NODE POOL
    node_pools = [
       {
        "name"             = "node-pool",
        "min_node_count"   = 2,
        "max_node_count"   = 20,
        "auto_repair"      = true,
        "auto_upgrade"     = true,
        "max_surge"        =  0,
        "max_unavailable"  = 1,
        "disk_size_gb"     = 50,
        "machine_type"     = "e2-highmem-4"
        "image_type"       = "cos_containerd"

       }
    ]

}



# processing Gke Cluster Module
module "processing_gke_cluster" {
  
  source = "./modules/gke-cluster"
  name                          = "processing_gke_cluster"
  project                       = var.project_defaults.project
  location                      = var.project_defaults.location
  network                       = module.vpc_network.network
  subnetwork                    = module.vpc_network.public_subnetwork
  cluster_secondary_range_name  = module.vpc_network.public_subnetwork_secondary_range_name
  services_secondary_range_name = module.vpc_network.public_services_secondary_range_name

  master_ipv4_cidr_block        = var.project_defaults.master_ipv4_cidr_block

  # This setting will make the cluster private
  enable_private_nodes          = "true"
  release_channel               = ""

 
  disable_public_endpoint       = "false"

  # private cluster
  
  master_authorized_networks_config = [
    {
      cidr_blocks = [
         {
          cidr_block   = "10.0.0.0/8"
          display_name = "private-net-gke-subnet"
        },
         {
          cidr_block   = "172.20.30.0/24"
          display_name = "private-net-gke-subnet for infosys-lan"
        },
      ]
    },
  ]

  resource_labels = {
    environment = "processing-prod"
    
  }
    
    # node pools details
    node_pools = [
       {
        "name"              = "node-pool",
        "min_node_count"    = 1,
        "max_node_count"    = 100,
        "auto_repair"       = true,
        "auto_upgrade"      = true,
        "max_surge"         =  0,
        "max_unavailable"   = 1,
        "disk_size_gb"      = 50,
        "machine_type"      = "n2-standard-48"
        "image_type"        = "cos_containerd"

       }
    ]

}






# service account details

module "gke_service_account" {
  source = "./modules/gke-service-account"
  name        = var.project_defaults.cluster_service_account_name
  project     = var.project_defaults.project
  description = var.project_defaults.cluster_service_account_description
}



# Network details

module "vpc_network" {

   source = "./modules/vpc-network"
   
  name_prefix                            = "gke-network-${random_string.suffix.result}"
  project                                = var.project_defaults.project
  region                                 = var.project_defaults.region
  cidr_block                             = var.project_defaults.vpc_cidr_block
  secondary_cidr_block                   = var.project_defaults.vpc_secondary_cidr_block
  public_subnetwork_secondary_range_name = var.project_defaults.public_subnetwork_secondary_range_name
  public_services_secondary_range_name   = var.project_defaults.public_services_secondary_range_name
  public_services_secondary_cidr_block   = var.project_defaults.public_services_secondary_cidr_block
  private_services_secondary_cidr_block  = var.project_defaults.private_services_secondary_cidr_block
  secondary_cidr_subnetwork_width_delta  = var.project_defaults.secondary_cidr_subnetwork_width_delta
  secondary_cidr_subnetwork_spacing      = var.project_defaults.secondary_cidr_subnetwork_spacing
}

# Use a random suffix to prevent overlap in network names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}