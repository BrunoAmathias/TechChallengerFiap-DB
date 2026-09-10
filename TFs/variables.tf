variable "neon_api_key" {
  description = "API Key utilizada pelo provider da Neon"
  type        = string
  sensitive   = true
}

variable "neon_org_id" {
  description = "ID da organização da Neon"
  type        = string
}