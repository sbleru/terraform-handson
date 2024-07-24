output "cloud_run_service_uri" {
  description = "Cloud Run Service URI"
  value       = google_cloud_run_v2_service.default.uri
}