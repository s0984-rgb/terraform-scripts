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

variable "CONSUL_HTTP_ADDR" {
  type        = string
  description = "Consul API address"
}

variable "consul_domain" {
  type        = string
  description = "Consul Domain"
  default     = "dc1.consul"
}

variable "consul_datacenter" {
  type        = string
  description = "Consul Datacenter"
  default     = "dc1"
}

variable "CONSUL_HTTP_TOKEN" {
  type        = string
  description = "Consul Token"
}

variable "CONSUL_SERVER_GOSSIP_KEY" {
  type        = string
  description = "Consul Server Gossip Key"
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
}
