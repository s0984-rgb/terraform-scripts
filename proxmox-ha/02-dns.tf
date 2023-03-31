resource "pihole_dns_record" "pve_record" {
  depends_on = [
    proxmox_lxc.haproxy_master,
    proxmox_lxc.haproxy_backup
  ]
  domain = "pve.${var.LOCAL_DOMAIN}"
  ip     = var.VIRTUAL_IP
}
