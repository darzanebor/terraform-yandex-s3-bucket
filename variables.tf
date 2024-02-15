variable "name" {
  description = "(Required) Bucket name."
}

variable "folder_id" {
  description = "(Required) Folder ID."
}

variable "max_size" {
  default     = null
  description = "(Optional) The size of bucket, in bytes."
}

variable "default_storage_class" {
  default = "STANDARD"
  description = "(Optional) Storage class which is used for storing objects by default. Available values are: 'STANDARD', 'COLD'."
}

variable "versioning" {
  default = false
  description = "(Optional) A state of versioning."
}

variable "cors_rule" {
  default = {}
  description = "(Optional) A rule of Cross-Origin Resource Sharing."
}

variable "anonymous_access_flags" {
  default = {}
  description = "(Optional) Provides various access to objects."
}

variable "https_certificate_id" {
  default = {}
  description = "(Optional) Manages https certificates for bucket."
}

variable "lifecycle_rules" {
  default = []
  description = "(Optional) A configuration of object lifecycle management."
}

variable "enable_encryption" {
  default = false
  description = "(Optional) A state of bucket encryption."
}

variable "bucket_logging" {
  default = {}
  description = "(Optional) A settings of bucket logging."
}

variable "bucket_permissions" {
  description = "Permissions for bucket access granted to SA"
  default     = ["READ", "WRITE"]
  type        = list(string)
}

variable "enable_folder_role" {
  description = "Enable folder role"
  default     = true
  type        = bool
}

variable "default_folder_role" {
  description = "Default folder role"
  default     = "storage.admin"
  type        = string
}
