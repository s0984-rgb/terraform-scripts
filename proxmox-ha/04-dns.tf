resource "pihole_dns_record" "pve_record" {
  depends_on = [
    null_resource.keepalived-playbook,
    null_resource.haproxy-playbook
  ]
  domain = var.proxmox_url
  ip     = var.VIRTUAL_IP
}

resource "pihole_dns_record" "nomad_record" {
  depends_on = [
    null_resource.keepalived-playbook,
    null_resource.haproxy-playbook
  ]
  domain = "nomad.homelab.local"
  ip     = var.VIRTUAL_IP
}

resource "pihole_dns_record" "vault_record" {
  depends_on = [
    null_resource.keepalived-playbook,
    null_resource.haproxy-playbook
  ]
  domain = "vault.homelab.local"
  ip     = var.VIRTUAL_IP
}
