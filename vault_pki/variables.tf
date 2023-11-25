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

variable "consul_domain" {
  type        = string
  description = "Consul Domain"
  default     = "dc1.consul"
}

variable "nomad_domain" {
  type        = string
  description = "Nomad Domain"
  default     = "dc1.nomad"
}
