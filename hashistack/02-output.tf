resource "vault_approle_auth_backend_role_secret_id" "vault_agent" {
  backend   = "approle"
  role_name = "vault-agent"
}

resource "vault_approle_auth_backend_role" "vault_agent" {
  backend        = vault_approle_auth_backend_role_secret_id.vault_agent.backend
  role_name      = vault_approle_auth_backend_role_secret_id.vault_agent.role_name
  token_policies = ["nomad", "consul", "token"]
}

resource "local_file" "ansible_inventory" {
  depends_on = [module.nomad_server, module.nomad_client]
  content = templatefile("templates/inventory.ini.tftpl",
    {
      group1_name      = "nomad-server",
      group1_hostnames = concat(module.nomad_server.instances.*.name),
      group2_name      = "nomad-client",
      group2_hostnames = concat(module.nomad_client.instances.*.name),
      group3_name      = "consul",
      group3_hostnames = concat(module.consul.instances.*.name),
      local_domain     = "${var.LOCAL_DOMAIN}",
      ansible_user     = "${var.CIUSER}"
    }
  )
  filename = "inventory.ini"
}

resource "local_file" "ansible_variables" {
  depends_on = [module.nomad_server, module.nomad_client]
  content = templatefile("templates/variables.yml.tftpl",
    {
      NOMAD_SERVER_GOSSIP_KEY  = var.NOMAD_SERVER_GOSSIP_KEY
      CONSUL_SERVER_GOSSIP_KEY = var.CONSUL_SERVER_GOSSIP_KEY
      VAULT_TOKEN              = var.VAULT_TOKEN
      VAULT_APPROLE_ID         = vault_approle_auth_backend_role.vault_agent.role_id
      VAULT_APPROLE_SECRET     = vault_approle_auth_backend_role_secret_id.vault_agent.secret_id
    }
  )
  filename = "variables.yml"
}

# resource "local_file" "ansible_variables" {
#   depends_on = [module.nomad_server, module.nomad_client]
#   content = templatefile("templates/variables.yml.tftpl",
#     {
#       NOMAD_SERVER_GOSSIP_KEY  = var.NOMAD_SERVER_GOSSIP_KEY
#       CONSUL_SERVER_GOSSIP_KEY = var.CONSUL_SERVER_GOSSIP_KEY
#       VAULT_TOKEN              = var.VAULT_TOKEN
#       VAULT_APPROLE_ID         = var.VAULT_APPROLE_ID
#       VAULT_APPROLE_SECRET     = var.VAULT_APPROLE_SECRET
#     }
#   )
#   filename = "variables.yml"
# }
