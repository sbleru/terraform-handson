variable "google_project_id" {
  description = "The Google Cloud project ID"
  type        = string
  default     = "my-tf-handson-eea0799a"
}

variable "google_primary_region" {
  description = "The primary region to deploy into"
  type        = string
  default     = "us-central1"
}