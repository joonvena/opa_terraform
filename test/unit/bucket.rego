package main

deny[msg] {
    not input.resource.google_storage_bucket.test
    msg = "Define the storage bucket resource"
}

deny[msg] {
    input.resource.google_storage_bucket.test.force_destroy != false
    msg = "Bucket should not be force deleted if there is content"
}
