variable "oidc_provider_arn" {
  description = "OIDC Provider ARN from EKS module"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC Provider URL (without https://)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "three-tier"
}

variable "service_account_name" {
  description = "Service account name for backend"
  type        = string
  default     = "backend-sa"
}
