output "name" {
 
  description = "The name of the cluster master."

  value = google_container_cluster.cluster.name
}
