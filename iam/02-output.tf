resource "local_file" "ansible_inventory" {
  depends_on = [module.docker]
  content = templatefile("templates/inventory.ini.tftpl",
    {
      group1_name      = "docker",
      group1_hostnames = concat(module.docker.instances.*.name),
      local_domain     = "${var.LOCAL_DOMAIN}",
      ansible_user     = "${var.CIUSER}"
    }
  )
  filename = "inventory.ini"
}