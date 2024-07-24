# Cloud Run Serviceの作成
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service
resource "google_cloud_run_v2_service" "default" {
  project  = var.google_project_id
  name     = "cloudrun-service"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      # env {
      #   name = "FOO"
      #   value = "bar"
      # }
    }

  }

  depends_on = [google_project_service.cloud_run_api]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# Publicアクセスを可能にする
resource "google_cloud_run_v2_service_iam_policy" "noauth" {
  project     = google_cloud_run_v2_service.default.project
  location    = google_cloud_run_v2_service.default.location
  name        = google_cloud_run_v2_service.default.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

# cloud run apiの有効化
resource "google_project_service" "cloud_run_api" {
  project = var.google_project_id
  service = "run.googleapis.com"

  # terraform destroyから除外
  disable_on_destroy = false
}
