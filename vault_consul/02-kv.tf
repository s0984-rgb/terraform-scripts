# Enabled KV secret engine in Vault
resource "vault_mount" "kv" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

# Add Consul encryption key to vault path expected by Vault agent
resource "vault_kv_secret_v2" "consul_encryption_key" {
  mount               = vault_mount.kv.path
  name                = "consul/config"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      encryption = "${var.CONSUL_SERVER_GOSSIP_KEY}"
    }
  )
}

# Add Consul encryption key to vault path expected by Vault agent
resource "vault_kv_secret_v2" "nomad_encryption_key" {
  mount               = vault_mount.kv.path
  name                = "nomad/config"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      encryption = "${var.NOMAD_SERVER_GOSSIP_KEY}"
    }
  )
}