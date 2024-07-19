### Yandex.Cloud Terraform S3 Bucket module
##### Example
```
module "bucket" {
  source = "github.com/darzanebor/terraform-yandex-s3-bucket.git"
  name   = "my-bucket"

  folder_id = "some_folder_id"

  versioning = false
  enable_encryption = false

  max_size = 10737418240
  default_storage_class = "STANDARD"

  anonymous_access_flags = {
      read = true
      list = true
  }

  lifecycle_rules = [{
      id      = "log"
      enabled = true
      prefix = "log/"
      transition = {
        days          = 30
        storage_class = "COLD"
      }
      expiration = {
        days = 90
      }
      noncurrent_version_transition = {
        days          = 30
        storage_class = "COLD"
      }
      noncurrent_version_expiration = {
        days = 90
      }
    },
  ]

  cors_rule = {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT"]
    allowed_origins = ["https://storage-cloud.example.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  https_certificate_id = {
    certificate_id = "some_cert_id"
  }

  bucket_logging = {
    target_bucket = "logging_bucket_id"
    target_prefix = "log/"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_iam_service_account.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_kms_symmetric_key.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key) | resource |
| [yandex_resourcemanager_folder_iam_binding.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_storage_bucket.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anonymous_access_flags"></a> [anonymous\_access\_flags](#input\_anonymous\_access\_flags) | (Optional) Provides various access to objects. | `map` | `{}` | no |
| <a name="input_bucket_logging"></a> [bucket\_logging](#input\_bucket\_logging) | (Optional) A settings of bucket logging. | `map` | `{}` | no |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | (Optional) A rule of Cross-Origin Resource Sharing. | `map` | `{}` | no |
| <a name="input_default_storage_class"></a> [default\_storage\_class](#input\_default\_storage\_class) | (Optional) Storage class which is used for storing objects by default. Available values are: 'STANDARD', 'COLD'. | `string` | `"STANDARD"` | no |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | (Optional) A state of bucket encryption. | `bool` | `false` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | (Required) Folder ID. | `any` | n/a | yes |
| <a name="input_https_certificate_id"></a> [https\_certificate\_id](#input\_https\_certificate\_id) | (Optional) Manages https certificates for bucket. | `map` | `{}` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | (Optional) A configuration of object lifecycle management. | `list` | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | (Optional) The size of bucket, in bytes. | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Bucket name. | `any` | n/a | yes |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | (Optional) A state of versioning. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_fqdn"></a> [bucket\_fqdn](#output\_bucket\_fqdn) | Domain of bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of bucket |
| <a name="output_bucket_sa_access_key"></a> [bucket\_sa\_access\_key](#output\_bucket\_sa\_access\_key) | SA access key |
| <a name="output_bucket_sa_secret_key"></a> [bucket\_sa\_secret\_key](#output\_bucket\_sa\_secret\_key) | SA secret key |
