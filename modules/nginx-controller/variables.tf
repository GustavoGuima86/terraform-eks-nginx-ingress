variable "cluster_name" {
  type = string
}

variable "oidc_id" {
  description = "The OIDC ID extracted from the issuer URL."
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "The ARN of the IAM OIDC provider associated with the EKS cluster."
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "The base64-encoded certificate authority data for the EKS cluster."
  type        = string
}

variable "cluster_endpoint" {
  description = "The API server endpoint for the EKS cluster."
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}