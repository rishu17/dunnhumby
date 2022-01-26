###### Google Cloud Storage ####

resource "google_storage_bucket" "dunnhumby_rishu" {
  name          = "dunnhumby_rishu"
  location      = "EU"
  force_destroy = true

  uniform_bucket_level_access = true

}

resource "google_storage_bucket_iam_member" "access_provider" {
  bucket = "dunnhumby_rishu"
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
  depends_on = [google_storage_bucket.dunnhumby_rishu]
}