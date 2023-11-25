path "consul/*" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "consul" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "pki_consul/*" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "pki_consul" {
    capabilities = ["create", "update", "read", "delete", "list"]
}

path "kv/consul/*" {
    capabilities = ["read"]
}

path "kv/data/consul/*" {
    capabilities = ["read"]
}
