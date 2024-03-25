
locals {
  workload_identity_config = !var.enable_workload_identity ? [] : var.identity_namespace == null ? [{
    identity_namespace = "${var.project}.svc.id.goog" }] : [{ identity_namespace = var.identity_namespace
  }]
}


# Create the GKE Cluster

resource "google_container_cluster" "cluster" {


  name        = var.name
  description = var.description

  project    = var.project
  location   = var.location
  network    = var.network
  subnetwork = var.subnetwork

  release_channel {
     channel = var.release_channel
   }


   # maintance window

   maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

 # enable_intranode_visibility = var.enable_intranode_visibility


    private_cluster_config  {
    enable_private_endpoint  = var.disable_public_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block

  }



#enable legacy 
  enable_legacy_abac = var.enable_legacy_abac

 
  # with no node pools.
  remove_default_node_pool = true

  initial_node_count = 1

  #  node_configcan
 
  dynamic "node_config" {
   
    for_each = [
      for x in [var.alternative_default_service_account] : x if var.alternative_default_service_account != null
    ]

    content {
      service_account = node_config.value
    }
  }



   # master authorized network access 
   dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }
  

   # authenticator security group
  dynamic "authenticator_groups_config" {
    for_each = [
      for x in [var.gsuite_domain_name] : x if var.gsuite_domain_name != null
    ]

    content {
      security_group = "gke-security-groups@${authenticator_groups_config.value}"
    }
  }
 
    # ip_allocation_policy

   ip_allocation_policy {
    
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
 

  #  workload_identity_config  {
   
    
  #   identity_namespace = "${var.project}.svc.id.goog"
    
  # }
  
   dynamic "workload_identity_config" {
     for_each = local.workload_identity_config

     content {
       identity_namespace =  workload_identity_config.value.identity_namespace
    }
 }

  resource_labels = var.resource_labels


# enable n/w policy
  addons_config {
    http_load_balancing {
      disabled = !var.http_load_balancing
    }

  # horizontal_pod_autoscaling {
  #      disabled = !var.horizontal_pod_autoscaling
  #    }

  network_policy_config {
      disabled = !var.enable_network_policy
    }
  }
  network_policy {
    enabled = var.enable_network_policy

    provider = var.enable_network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED"
  }


    master_auth {
         
         username =  var.basic_auth_username
         password =  var.basic_auth_password

        
         client_certificate_config {
           issue_client_certificate = true
         }
   }


}



  # lifecycle {
  #   ignore_changes = [
  #     node_config,
  #   ]
  # }








# Prepare locals to keep the code cleaner


locals {
  latest_version     = data.google_container_engine_versions.location.latest_master_version
  kubernetes_version = var.kubernetes_version != "latest" ? var.kubernetes_version : local.latest_version
  network_project    = var.network_project != "" ? var.network_project : var.project

  node_pools = {
    for x in var.node_pools : x.name => x
  }
}

// Get available master versions in our location to determine the latest version
data "google_container_engine_versions" "location" {
  location = var.location
  project  = var.project
}


resource "google_container_node_pool" "gke_np" {
 
  for_each =  local.node_pools
  name     = each.key
  project  = var.project
  location = var.location
  #cluster  = module.google_container_cluster" "gke"
  
 # cluster    = module.gke_cluster.cluster.id
  cluster     = google_container_cluster.cluster.name
  #cluster    = module.gke_cluster.cluster.id
 

  initial_node_count = "1"
 
   lifecycle {
    ignore_changes = [initial_node_count]
  }


  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  management {
    auto_repair  = each.value.auto_repair
    auto_upgrade = each.value.auto_upgrade
  }

  node_config {

    machine_type = each.value.machine_type
    image_type   = each.value.image_type
    

    labels = var.labels
    
    disk_size_gb = each.value.disk_size_gb
    # disk_type    = "pd-standard"
    # preemptible  = false

   # service_account = module.gke_service_account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }



  timeouts {
    # create = "30m"
    # update = "30m"
    # delete = "30m"
  }
}
