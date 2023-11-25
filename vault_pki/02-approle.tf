resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "vault_agent" {
  backend   = vault_auth_backend.approle.path
  role_name = "vault-agent"
  token_policies = [
    vault_policy.token.name,
    vault_policy.consul.name,
    vault_policy.nomad.name
  ]
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.vault_agent.role_name
}