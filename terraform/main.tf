terraform {
  backend "gcs" {
    bucket      = "opa-tf-state"
    prefix      = "terraform/state"
    credentials = "../.secrets/gcp-creds.json"
  }
}

provider "google" {
  project     = "terraform-playground-30"
  region      = "europe-west1"
  credentials = "../.secrets/gcp-creds.json"
}

resource "google_storage_bucket" "test" {
  name          = "opa-test-bucket"
  location      = "europe-west1"
  force_destroy = false
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.test.name
  source = "opafunction/index.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "HelloOpa"
  description = "Function to test OPA"
  runtime     = "go112"

  available_memory_mb   = 256
  trigger_http          = true
  source_archive_bucket = google_storage_bucket.test.name
  source_archive_object = google_storage_bucket_object.archive.name
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
