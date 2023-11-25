resource "nomad_acl_auth_method" "oidc" {
  name           = "oidc"
  type           = "OIDC"
  token_locality = "global"
  max_token_ttl  = "10m0s"
  default        = true

  config {
    oidc_discovery_url = "https://uk.auth0.com/"
    oidc_client_id     = "someclientid"
    oidc_client_secret = "someclientsecret-t"
    bound_audiences    = ["someclientid"]
    allowed_redirect_uris = [
      "http://localhost:4649/oidc/callback",
      "http://localhost:4646/ui/settings/tokens",
    ]
    list_claim_mappings = {
      "http://nomad.internal/roles" : "roles"
    }
  }
}
