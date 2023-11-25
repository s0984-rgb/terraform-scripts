terraform {
  backend "local" {}
}

provider "vault" {
  # Configuration options
  address = var.VAULT_ADDR
  token   = var.VAULT_TOKEN
}

provider "nomad" {
  address   = var.NOMAD_ADDR
  region    = "dc1"
  ca_pem    = vault_pki_secret_backend_cert.vault_nomad_backend.ca_chain
  cert_pem  = vault_pki_secret_backend_cert.vault_nomad_backend.certificate
  key_pem   = vault_pki_secret_backend_cert.vault_nomad_backend.private_key
  secret_id = vault_nomad_secret_backend.nomad.token
}
