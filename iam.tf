resource "yandex_iam_service_account" "this" {
  name        = var.name
  description = "Service account to manage s3 bucket ${var.name} "
  folder_id   = var.folder_id
}

resource "yandex_iam_service_account_static_access_key" "this" {
  service_account_id = yandex_iam_service_account.this.id
  description        = "Static access key for object storage"
}

resource "yandex_resourcemanager_folder_iam_binding" "this" {
  count = var.enable_folder_role ? 1 : 0
  folder_id = var.folder_id
  role      = var.default_folder_role

  members = [
    "serviceAccount:${yandex_iam_service_account.this.id}",
  ]
}
