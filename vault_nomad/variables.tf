variable "VAULT_ADDR" {
  type        = string
  description = "Vault Address"
}

variable "VAULT_TOKEN" {
  type        = string
  description = "Vault Access Token"
}

variable "home_domain" {
  type        = string
  description = "Domain"
}

variable "NOMAD_ADDR" {
  type        = string
  description = "Nomad API address"
}

variable "nomad_domain" {
  type        = string
  description = "Nomad Domain"
  default     = "dc1.nomad"
}

variable "NOMAD_SERVER_GOSSIP_KEY" {
  type        = string
  description = "Consul Server Gossip Key"
  sensitive   = true
}

variable "NOMAD_TOKEN" {
  type        = string
  description = "value"
  sensitive   = true
}
