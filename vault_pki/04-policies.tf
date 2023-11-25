resource "vault_policy" "token" {
  name = "token"

  policy = <<-EOT
    path "auth/token/create" {
        capabilities = ["create", "update", "read"]
    }

    path "auth/token/renew-self" {
        capabilities = ["read", "update", "read"]
    }
    EOT
}

resource "vault_policy" "consul" {
  name = "consul"

  policy = <<-EOT
    path "consul/*" {
        capabilities = ["create", "update", "read"]
    }

    path "consul" {
        capabilities = ["create", "update", "read"]
    }

    path "pki_consul/*" {
        capabilities = ["create", "update", "read"]
    }

    path "pki_consul" {
        capabilities = ["create", "update", "read"]
    }

    path "kv/consul/*" {
        capabilities = ["read"]
    }

    path "kv/data/consul/*" {
        capabilities = ["read"]
    }
    EOT
}

resource "vault_policy" "nomad" {
  name = "nomad"

  policy = <<-EOT
    path "nomad/*" {
        capabilities = ["create", "update", "read"]
    }

    path "nomad" {
        capabilities = ["create", "update", "read"]
    }

    path "pki_nomad/*" {
        capabilities = ["create", "update", "read"]
    }

    path "pki_nomad" {
        capabilities = ["create", "update", "read"]
    }

    path "kv/nomad/*" {
        capabilities = ["read"]
    }

    path "kv/data/nomad/*" {
        capabilities = ["read"]
    }
    EOT
}

resource "vault_policy" "vault_admin" {
  name   = "vault-admin"
  policy = <<EOT
# Read system health check
path "sys/health"
{
  capabilities = ["read", "sudo"]
}

# Create and manage ACL policies broadly across Vault

# List existing policies
path "sys/policies/acl"
{
  capabilities = ["list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage authentication methods broadly across Vault

# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Enable and manage the key/value secrets engine at `secret/` path

# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secrets engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read"]
}

path "kv/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}
