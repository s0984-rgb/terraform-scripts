resource "vault_jwt_auth_backend" "oidc" {
  description        = "OIDC authentication backend for homelab vault"
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "http://keycloak.homelab.local/realms/homelab"
  oidc_client_id     = "vault"
  oidc_client_secret = "fANNBZiOyFZlwjYsvMjMZNAvizrDRqQy"
  default_role       = "test-role"
}

resource "vault_jwt_auth_backend_role" "oidc" {
  backend        = vault_jwt_auth_backend.oidc.path
  role_name      = "test-role"
  token_policies = ["default"]

  bound_audiences       = ["vault"]
  user_claim            = "sub"
  groups_claim          = "groups"
  role_type             = "oidc"
  allowed_redirect_uris = ["https://vault.homelab.local/ui/vault/auth/oidc/oidc/callback"]
}

resource "vault_identity_group" "vault_admin" {
  name     = "admin"
  type     = "external"
  policies = [vault_policy.vault_admin.name, "nomad", "consul", "default"]
}

resource "vault_identity_group_alias" "vault_admin" {
  name           = "admin"
  mount_accessor = vault_jwt_auth_backend.oidc.accessor
  canonical_id   = vault_identity_group.vault_admin.id
}

resource "vault_identity_group" "vault_user" {
  name     = "user"
  type     = "external"
  policies = ["default"]
}

resource "vault_identity_group_alias" "vault_user" {
  name           = "user"
  mount_accessor = vault_jwt_auth_backend.oidc.accessor
  canonical_id   = vault_identity_group.vault_user.id
}
