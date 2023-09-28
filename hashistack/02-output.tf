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
      NOMAD_SERVER_GOSSIP_KEY  = var.NOMAD_SERVER_GOSSIP_KEY,
      CONSUL_SERVER_GOSSIP_KEY = var.CONSUL_SERVER_GOSSIP_KEY
      VAULT_TOKEN = var.VAULT_TOKEN
    }
  )
  filename = "variables.yml"
}
