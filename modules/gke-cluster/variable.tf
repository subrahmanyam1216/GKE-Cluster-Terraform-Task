variable "project" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "location" {
  description = "The location  the cluster in"
  type        = string
}

variable "name" {
  description = "The name of the cluster"
  type        = string
}

variable "network" {
  description = "A reference VPC network to host the cluster in"
  type        = string
}

variable "subnetwork" {
  description = "A reference  subnetwork to host the cluster in"
  type        = string
}

variable "cluster_secondary_range_name" {
  description = "The name of the secondary range within the subnetwork for the cluster to use"
  type        = string
}


variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations "
  type        = string
  default     = "05:00"
}

# variable "stub_domains" {
#   description = "Map of stub domains  to an external DNS server"
#   type        = map(string)
#   default     = {}
# }

# variable "non_masquerade_cidrs" {
#   description = "List of strings in CIDR notation that specify the IP address ranges  ."
#   type        = list(string)
#   default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
# }

variable "ip_masq_resync_interval" {
  description = "The interval at which the agent attempts to sync its ConfigMap file from the disk."
  type        = string
  default     = "60s"
}

# variable "ip_masq_link_local" {
#   description = "Whether to masquerade traffic to the link-local prefix (169.254.0.0/16)."
#   type        = bool
#   default     = false
# }



variable "enable_legacy_abac" {
  description = "Whether to enable legacy Attribute-Based Access Control (ABAC). "
  type        = bool
  default     = false
}

variable "enable_network_policy" {
  description = "Whether to enable Kubernetes NetworkPolicy on the master, "
  type        = bool
  default     = true
}

variable "basic_auth_username" {
  description = "The username used for basic auth"
  type        = string
  default     = ""
}

variable "basic_auth_password" {
  description = "The password used for basic auth"
  type        = string
  default     = ""
}

variable "enable_client_certificate_authentication" {
  description = "Whether to enable authentication "
  type        = bool
  default     = false
}


variable "gsuite_domain_name" {
  description = "The domain name for use with Google security groups in Kubernetes RBAC.`."
  type        = string
  default     = null
}

variable "secrets_encryption_kms_key" {
  description = "The Cloud KMS key to use for the encryption of secrets in etcd"
  type        = string
  default     = null
}

variable "enable_vertical_pod_autoscaling" {
  description = "Whether to enable Vertical Pod Autoscaling"
  type        = string
  default     = false
}

variable "services_secondary_range_name" {
  description = "The name of the secondary range within the subnetwork for the services to use"
  type        = string
  default     = null
}

variable "enable_workload_identity" {
  description = "Enable Workload Identity on the cluster"
  default     = false
  type        = bool
}

variable "identity_namespace" {
  description = "Workload Identity Namespace. "
  default     = null
  type        = string
}

variable "node_pools" {
  description = ""
  type        = list(object({
    name = string
    min_node_count = number
    max_node_count = number
    auto_repair = bool
    auto_upgrade = bool
    machine_type = string
    image_type = string
    disk_size_gb = number
  }))
  default     = null
  
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters."
  type        = string
  default     = "latest"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. "
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. "
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "horizontal_pod_autoscaling" {
  description = "Whether to enable the horizontal pod autoscaling addon"
  type        = bool
  default     = true
}

variable "alternative_default_service_account" {
  description = "Alternative Service Account to be used by the Node VMs. ."
  type        = string
  default     = null
}

variable "resource_labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  type        = map(any)
  default     = {}
}

variable "labels" {
  description = ""
  type        = map(string)
  default     = {}
}


variable "release_channel" {
  description = ""
  type        = string
}
variable "description" {
  description = "The description of the cluster"
  type        = string
  default     = ""
}



variable "http_load_balancing" {
  description = "Whether to enable the load balancing "
  type        = bool
  default     = true
}

variable "enable_private_nodes" {
  description = "Control whether nodes have internal IP addresses only."
  type        = bool
  default     = false
}

variable "disable_public_endpoint" {
  description = "Control whether the master's internal IP address is used as the cluster endpoint."
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network. "
  type        = string
  default     = ""
}

variable "network_project" {
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  type        = string
  default     = ""
}

variable "master_authorized_networks_config" {
  description = <<EOF
  The desired configuration options for master authorized networks. 
  ### example format ###
  master_authorized_networks_config = [{
    cidr_blocks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "example_network"
    }],
  }]
EOF
  type        = list(any)
  default     = []
}