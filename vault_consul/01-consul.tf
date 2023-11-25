# Create Consul client certificate for Vault backend
resource "vault_pki_secret_backend_cert" "vault_consul_backend" {
  backend              = "pki_consul"
  name                 = "consul-dc1"
  common_name          = "client.${var.consul_domain}"
  alt_names            = ["vault.${var.consul_domain}"]
  exclude_cn_from_sans = true
  ttl                  = 2764800
}

resource "vault_consul_secret_backend" "consul" {
  depends_on  = [vault_pki_secret_backend_cert.vault_consul_backend]
  path        = "consul"
  description = "Manages the Consul backend"
  address     = var.CONSUL_HTTP_ADDR
  token       = var.CONSUL_HTTP_TOKEN
  ca_cert     = vault_pki_secret_backend_cert.vault_consul_backend.ca_chain
  client_cert = vault_pki_secret_backend_cert.vault_consul_backend.certificate
  client_key  = vault_pki_secret_backend_cert.vault_consul_backend.private_key
}

resource "vault_consul_secret_backend_role" "consul_server" {
  name    = "consul-server-role"
  backend = vault_consul_secret_backend.consul.path

  consul_policies = [
    consul_acl_policy.consul_server.name
  ]
}

resource "vault_consul_secret_backend_role" "consul_client" {
  name    = "consul-client-role"
  backend = vault_consul_secret_backend.consul.path

  consul_policies = [
    consul_acl_policy.consul_client.name
  ]
}

resource "vault_consul_secret_backend_role" "nomad_server" {
  name    = "nomad-server-role"
  backend = vault_consul_secret_backend.consul.path

  consul_policies = [
    consul_acl_policy.nomad_server.name
  ]
}

resource "vault_consul_secret_backend_role" "nomad_client" {
  name    = "nomad-client-role"
  backend = vault_consul_secret_backend.consul.path

  consul_policies = [
    consul_acl_policy.nomad_client.name
  ]
}
