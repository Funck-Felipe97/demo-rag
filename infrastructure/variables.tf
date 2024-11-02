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

variable "domain_prefix" {
  description = "Cognito Domain Prefix"
  type        = string  
  default     = "fcfunck-demo-ai"
}

variable "allowed_oauth_flows" {
  description = "Allowed Oauth Flow"
  type        = list(string)  
  default     = ["implicit"]
}

variable "allowed_oauth_scopes" {
  description = "Allowed Oauth Flow"
  type        = list(string)  
  default     = ["openid", "email", "phone"]
}

variable "callbacks_urls" {
  description = "Callbacks URLs"
  type        = list(string)  
  default     = ["https://example.com"]
}

variable "user_files_tb_name" {
  type = string
  description = "User Files Table Name"
  default = "UserFiles"
}
