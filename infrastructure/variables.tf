variable "bucket_name" {
  description = "S3 User Files Bucket Name"
  type        = string
  default     = "fcfunck-demo-ai-user-files"
}

variable "user_pool_name" {
  description = "Congnito User Pool Name"
  type        = string
  default     = "demo-ai-user-pool"
}

variable "user_pool_client_name" {
  description = "Congnito User Pool Client Name"
  type        = string
  default     = "user_pool_client"
}

variable "user_identity_pool" {
  description = "Cognito Identity Pool Name"
  type        = string
  default     = "demo-ai-identity-pool"
}

variable "cognito_role_name" {
  description = "Cognito Authenticated Role Name"
  type        = string
  default     = "demo-ai-cognito-authenticated-role"
}