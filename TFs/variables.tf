variable "neon_api_key" {
  description = "API Key utilizada pelo provider da Neon"
  type        = string
  sensitive   = true
}

variable "neon_org_id" {
  description = "ID da organização da Neon"
  type        = string
}

variable "atlas_org_id" {
  description = "ID da organização no MongoDB Atlas"
  type        = string
}

variable "atlas_public_key" {
  description = "Public key da API key do Atlas (null = usa MONGODB_ATLAS_PUBLIC_KEY)"
  type        = string
  default     = null
}

variable "atlas_private_key" {
  description = "Private key da API key do Atlas (null = usa MONGODB_ATLAS_PRIVATE_KEY)"
  type        = string
  default     = null
  sensitive   = true
}

variable "atlas_region" {
  description = "Região AWS do cluster M0 no formato do Atlas (o M0 não está disponível em todas as regiões)"
  type        = string
  default     = "US_EAST_1"
}

variable "atlas_allowed_cidrs" {
  description = "CIDRs liberados no Atlas. Os nós do EKS usam IPs públicos dinâmicos, por isso o padrão é aberto (acesso protegido por usuário e senha)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
