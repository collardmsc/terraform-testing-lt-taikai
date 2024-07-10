variable "bucket_name" {
  description = "S3 Bucket Name"
  default     = null
  type        = string

  validation {
    condition = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "S3 Bucket name must be between 3 and 63 characters"
  }
}
