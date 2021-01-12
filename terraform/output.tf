output "cloud_function_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}
