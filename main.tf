resource "yandex_kms_symmetric_key" "this" {
  count             = var.enable_encryption ? 1 : 0
  name              = "bucket-${var.name}-kms-symmetric-key"
  description       = "bucket ${var.name} kms symmetric key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

resource "yandex_storage_bucket" "this" {
  bucket     = var.name
  access_key = yandex_iam_service_account_static_access_key.this.access_key
  secret_key = yandex_iam_service_account_static_access_key.this.secret_key

  max_size = var.max_size
  default_storage_class = var.default_storage_class

  versioning {
    enabled = var.versioning
  }

  dynamic "https" {
    for_each    = var.https_certificate_id != {} ? [var.https_certificate_id] : []
    iterator    = cert
    content {
      certificate_id = lookup(cert.value, "certificate_id")
    }
  }

  dynamic "cors_rule" {
    for_each    = var.cors_rule != {} ? [var.cors_rule] : []
    iterator    = rule
    content {
      allowed_headers = lookup(rule.value, "allowed_headers")
      allowed_methods = lookup(rule.value, "allowed_methods", null)
      allowed_origins = lookup(rule.value, "allowed_origins", false)
      expose_headers  = lookup(rule.value, "expose_headers", false)
      max_age_seconds = lookup(rule.value, "max_age_seconds", 3000)
    }
  }

  dynamic "anonymous_access_flags" {
    for_each    = var.anonymous_access_flags != {} ? [var.anonymous_access_flags] : []
    iterator    = anonymous_flags
    content {
      read = lookup(anonymous_flags.value, "read", false)
      list = lookup(anonymous_flags.value, "list", false)
    }
  }

  dynamic "lifecycle_rule" {
    for_each    = var.lifecycle_rules != [] ? var.lifecycle_rules : []
    iterator    = lifecycle_rule
    content {
      id      = lookup(lifecycle_rule.value, "id")
      enabled = lookup(lifecycle_rule.value, "list", false)
      prefix  = lookup(lifecycle_rule.value, "prefix")

      dynamic "transition" {
        for_each    = try([lookup(lifecycle_rule.value, "transition")],[])
        iterator    = transition
        content {
          days          = lookup(transition.value, "days", null)
          date          = lookup(transition.value, "date", null)
          storage_class = lookup(transition.value, "storage_class", false)
        }
      }

      dynamic "expiration" {
        for_each    = try([lookup(lifecycle_rule.value, "expiration")],[])
        iterator    = expiration
        content {
          days          = lookup(expiration.value, "days", null)
          date          = lookup(expiration.value, "date", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }
      dynamic "noncurrent_version_transition" {
        for_each    = try([lookup(lifecycle_rule.value, "noncurrent_version_transition")],[])
        iterator    = version_transition
        content {
          days          = lookup(version_transition.value, "days", null)
          storage_class = lookup(version_transition.value, "storage_class", false)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each    = try([lookup(lifecycle_rule.value, "noncurrent_version_expiration")],[])
        iterator    = version_expiration
        content {
          days          = lookup(version_expiration.value, "days", null)
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each    = try(yandex_kms_symmetric_key.this,[])
    iterator    = key
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = lookup(key.value, "id")
          sse_algorithm     = "aws:kms"
        }
      }
    }
  }

  dynamic "logging" {
    for_each    = var.bucket_logging != {} ? [var.bucket_logging] : []
    iterator    = logging
    content {
      target_bucket = lookup(logging.value, "target_bucket")
      target_prefix = lookup(logging.value, "target_prefix")
    }
  }

  grant {
    id          = yandex_iam_service_account.this.id
    type        = "CanonicalUser"
    permissions = var.bucket_permissions
  }
}
