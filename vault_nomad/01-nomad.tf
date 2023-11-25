resource "vault_pki_secret_backend_cert" "vault_nomad_backend" {
  backend              = "pki_nomad"
  name                 = "nomad-dc1"
  common_name          = "client.${var.nomad_domain}"
  alt_names            = ["vault.${var.nomad_domain}"]
  exclude_cn_from_sans = true
  ttl                  = 432000
}

resource "vault_nomad_secret_backend" "nomad" {
  backend                   = "nomad"
  description               = "Nomad secrets backend"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "7200"
  max_ttl                   = "240"
  address                   = var.NOMAD_ADDR
  token                     = var.NOMAD_TOKEN
  ttl                       = "120"
}

# Provider is giving weird error:
# error reading ACLPolicy "operator": Unexpected response code: 500 (No path to region)

# resource "nomad_namespace" "test" {
#   name        = "test"
#   description = "Test Namespace environment"
# }

# resource "nomad_acl_policy" "user" {
#   name        = "user"
#   description = "Submit jobs to the dev environment."

#   rules_hcl = <<-EOT
#     namespace "test" {
#         capabilities = ["list-jobs", "parse-job", "read-job", "submit-job", "read-logs", "alloc-exec", "scale-job"]
#     }
#     node {
#         policy = "read"
#     }
#     agent {
#         policy = "deny"
#     }
#     operator {
#         policy = "deny"
#     }
#     host_volume "*" {
#         policy = "write"
#     }
#     plugin {
#         policy = "read"
#     }
#     EOT
# }

# resource "nomad_acl_policy" "global_operator" {
#   name        = "operator"
#   description = "Global Operator ACL policy."

#   rules_hcl = <<EOT
# namespace "*" {
#     policy = "write"
# }

# node {
#     policy = "write"
# }

# agent {
#     policy = "write"
# }

# operator {
#     policy = "write"
# }

# host_volume "*" {
#     policy = "write"
# }

# plugin {
#     policy = "list"
# }
# EOT
# }

# resource "vault_nomad_secret_role" "user" {
#   backend  = vault_nomad_secret_backend.nomad.backend
#   role     = "test_user"
#   type     = "client"
#   policies = [nomad_acl_policy.user.name]
# }

# resource "vault_nomad_secret_role" "operator" {
#   backend  = vault_nomad_secret_backend.nomad.backend
#   role     = "operator"
#   type     = "management"
#   policies = [nomad_acl_policy.global_operator.name]
# }
