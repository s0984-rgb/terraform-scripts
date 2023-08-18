resource "proxmox_lxc" "lxc" {
  count        = var.lxc_count
  target_node  = var.target_nodes[count.index % length(var.target_nodes)]
  hostname     = "${var.hostname}${count.index}"
  onboot       = true
  startup      = var.startup_order
  ostemplate   = var.ostemplate
  password     = var.password
  unprivileged = true
  cores        = var.cores
  memory       = var.memory
  searchdomain = var.searchdomain
  start        = true
  nameserver   = var.nameserver

  tags = var.tags

  // Terraform will crash without rootfs defined
  rootfs {
    storage = var.storage
    size    = var.size
  }

  network {
    name   = var.iname
    bridge = var.bridge
    ip     = "${var.ips[count.index]}/${var.cidr}"
    gw     = var.gw
  }

  ssh_public_keys = file(var.public_key)
}

resource "pihole_dns_record" "lxc" {
  depends_on = [
    proxmox_lxc.lxc
  ]
  for_each = { for idx, item in proxmox_lxc.lxc.* : idx => item }
  domain = "${each.value.hostname}.${var.searchdomain}"
  ip     = replace(each.value.network[0].ip, "/${var.cidr}", "")
}