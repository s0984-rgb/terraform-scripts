// ROOT CA //

# Enable Root CA
resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
  default_lease_ttl_seconds = 31536000
  max_lease_ttl_seconds     = 63072000
}

# Generate Root CA certificate
resource "vault_pki_secret_backend_root_cert" "root" {
  depends_on            = [vault_mount.pki]
  backend               = vault_mount.pki.path
  type                  = "internal"
  common_name           = "${var.home_domain} Root CA"
  ttl                   = 315360000
  format                = "pem"
  private_key_format    = "der"
  key_type              = "rsa"
  key_bits              = 4096
  exclude_cn_from_sans  = true
  ou                    = "Vault"
  organization          = "My Homelab"
  country               = "Canada"
  province              = "Quebec"
  locality              = "Montreal"
  permitted_dns_domains = ["${var.home_domain}", "${var.consul_domain}", "${var.nomad_domain}", "localhost"]
}

# Create Root issuer
resource "vault_pki_secret_backend_issuer" "root" {
  backend     = vault_pki_secret_backend_root_cert.root.backend
  issuer_ref  = vault_pki_secret_backend_root_cert.root.issuer_id
  issuer_name = "RootCAIssuer"
}

# Create default issuer for Root CA
resource "vault_pki_secret_backend_config_issuers" "root" {
  backend                       = vault_mount.pki.path
  default                       = vault_pki_secret_backend_issuer.root.issuer_id
  default_follows_latest_issuer = true
}

// CONSUL CA //

# Enable Consul CA
resource "vault_mount" "consul_pki" {
  path                      = "pki_consul"
  type                      = "pki"
  default_lease_ttl_seconds = 31536000
  max_lease_ttl_seconds     = 63072000
}

# Create CSR for Consul CA
resource "vault_pki_secret_backend_intermediate_cert_request" "consul" {
  depends_on   = [vault_mount.consul_pki]
  backend      = vault_mount.consul_pki.path
  type         = "internal"
  common_name  = "${var.consul_domain} Intermediate Authority"
  ou           = "Vault"
  organization = "My Homelab"
  country      = "Canada"
  province     = "Quebec"
  locality     = "Montreal"
}

# Sign the CSR for Consul CA
resource "vault_pki_secret_backend_root_sign_intermediate" "consul" {
  depends_on            = [vault_pki_secret_backend_intermediate_cert_request.consul, vault_pki_secret_backend_config_issuers.root]
  backend               = vault_mount.pki.path
  csr                   = vault_pki_secret_backend_intermediate_cert_request.consul.csr
  common_name           = vault_pki_secret_backend_intermediate_cert_request.consul.common_name
  use_csr_values        = true
  exclude_cn_from_sans  = true
  permitted_dns_domains = ["${var.consul_domain}", "${var.home_domain}", "localhost"]
}

# Set the newly signed certificate in the intermediate CA
resource "vault_pki_secret_backend_intermediate_set_signed" "consul" {
  depends_on  = [vault_mount.consul_pki, vault_pki_secret_backend_root_sign_intermediate.consul]
  backend     = vault_mount.consul_pki.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.consul.certificate
}

# Create role for Consul CA
resource "vault_pki_secret_backend_role" "consul" {
  depends_on       = [vault_pki_secret_backend_intermediate_set_signed.consul]
  backend          = vault_mount.consul_pki.path
  name             = "consul-dc1"
  ttl              = 86400
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["${var.home_domain}", "${var.consul_domain}"]
  allow_subdomains = true
}

// NOMAD CA //

# Enable Nomad CA
resource "vault_mount" "nomad_pki" {
  path                      = "pki_nomad"
  type                      = "pki"
  default_lease_ttl_seconds = 31536000
  max_lease_ttl_seconds     = 63072000
}

# Create CSR for Nomad CA
resource "vault_pki_secret_backend_intermediate_cert_request" "nomad" {
  depends_on   = [vault_mount.nomad_pki]
  backend      = vault_mount.nomad_pki.path
  type         = "internal"
  common_name  = "${var.nomad_domain} Intermediate Authority"
  ou           = "Vault"
  organization = "My Homelab"
  country      = "Canada"
  province     = "Quebec"
  locality     = "Montreal"
}

# Sign the CSR for Nomad CA
resource "vault_pki_secret_backend_root_sign_intermediate" "nomad" {
  depends_on            = [vault_pki_secret_backend_intermediate_cert_request.nomad, vault_pki_secret_backend_config_issuers.root]
  backend               = vault_mount.pki.path
  csr                   = vault_pki_secret_backend_intermediate_cert_request.nomad.csr
  common_name           = vault_pki_secret_backend_intermediate_cert_request.nomad.common_name
  use_csr_values        = true
  exclude_cn_from_sans  = true
  permitted_dns_domains = ["${var.nomad_domain}", "${var.home_domain}"]
}

# Set the newly signed certificate in the intermediate CA
resource "vault_pki_secret_backend_intermediate_set_signed" "nomad" {
  depends_on  = [vault_mount.nomad_pki, vault_pki_secret_backend_root_sign_intermediate.nomad]
  backend     = vault_mount.nomad_pki.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.nomad.certificate
}

# Create role for Nomad CA
resource "vault_pki_secret_backend_role" "nomad" {
  depends_on       = [vault_pki_secret_backend_intermediate_set_signed.nomad]
  backend          = vault_mount.nomad_pki.path
  name             = "nomad-dc1"
  ttl              = 86400
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["${var.home_domain}", "${var.nomad_domain}"]
  allow_subdomains = true
}
