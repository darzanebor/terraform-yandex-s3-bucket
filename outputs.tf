output "bucket_fqdn" {
  description = "Domain of bucket"
  value       = yandex_storage_bucket.this.bucket_domain_name
}

output "bucket_id" {
  description = "ID of bucket"
  value       = yandex_storage_bucket.this.id
}

output "bucket_rw_access_key" {
  description = "SA access key"
  value       = yandex_iam_service_account_static_access_key.this.access_key
}

output "bucket_rw_secret_key" {
  description = "SA secret key"
  value       = yandex_iam_service_account_static_access_key.this.secret_key
}
