resource "pihole_dns_record" "pve_record" {
  domain = "pve.${var.LOCAL_DOMAIN}"
  ip     = var.VIRTUAL_IP
}
