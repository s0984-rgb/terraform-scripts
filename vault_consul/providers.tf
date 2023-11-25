terraform {
  backend "local" {}
}

provider "vault" {
  # Configuration options
  address = var.VAULT_ADDR
  token   = var.VAULT_TOKEN
}

provider "consul" {
  address    = var.CONSUL_HTTP_ADDR
  datacenter = var.consul_datacenter
  ca_pem     = vault_pki_secret_backend_cert.vault_consul_backend.ca_chain
  cert_pem   = vault_pki_secret_backend_cert.vault_consul_backend.certificate
  key_pem    = vault_pki_secret_backend_cert.vault_consul_backend.private_key
  token      = vault_consul_secret_backend.consul.token
}