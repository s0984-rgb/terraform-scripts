resource "local_file" "ansible_inventory" {
  depends_on = [proxmox_lxc.haproxy_master, proxmox_lxc.haproxy_backup]
  content = templatefile("templates/inventory.ini.tftpl",
    {
      proxmox_hostnames       = concat([var.PM_MASTER_NODE], var.PM_BACKUP_NODES),
      keepalived_primary_host = "${var.MASTER_IP}",
      keepalived_backup_hosts = "${var.BACKUP_IPS}",
      local_domain            = "${var.LOCAL_DOMAIN}"
    }
  )
  filename = "inventory.ini"
}
