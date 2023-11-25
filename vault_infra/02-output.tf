resource "local_file" "ansible_inventory" {
  depends_on = [module.vault]
  content = templatefile("templates/inventory.ini.tftpl",
    {
      group1_name      = "vault",
      group1_hostnames = concat(module.vault.instances.*.name),
      local_domain     = "${var.LOCAL_DOMAIN}",
      ansible_user     = "${var.CIUSER}"
    }
  )
  filename = "inventory.ini"
}
