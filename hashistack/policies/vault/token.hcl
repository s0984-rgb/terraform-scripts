path "auth/token/create" {
    capabilities = ["create", "update", "read"]
}

path "auth/token/renew-self" {
    capabilities = ["read", "update", "read"]
}
