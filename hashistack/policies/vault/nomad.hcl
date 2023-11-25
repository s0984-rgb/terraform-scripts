path "nomad/*" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "nomad" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "pki_nomad/*" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "pki_nomad" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "kv/nomad/*" {
    capabilities = ["read"]
}

path "kv/data/nomad/*" {
    capabilities = ["read"]
}
