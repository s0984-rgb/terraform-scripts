resource "proxmox_lxc" "haproxy_master" {
  target_node  = var.PM_MASTER_NODE
  hostname     = "haproxy-master"
  onboot       = true
  startup      = "order=1"
  ostemplate   = var.LXC_TEMPLATE
  password     = var.LXC_PASSWORD
  unprivileged = true
  cores        = var.CORES
  memory       = var.MEMORY
  searchdomain = var.LOCAL_DOMAIN
  start        = true
  nameserver   = var.NAMESERVER

  tags = local.master_tags

  // Terraform will crash without rootfs defined
  rootfs {
    storage = var.STORAGE_NAME
    size    = var.STORAGE_SIZE
  }

  network {
    name   = var.INTERFACE_NAME
    bridge = var.BRIDGE_NAME
    ip     = "${var.MASTER_IP}/${var.CIDR_BLOCK}"
    gw     = var.GATEWAY
  }

  ssh_public_keys = file(var.public_key)
}

resource "proxmox_lxc" "haproxy_backup" {
  count        = var.BACKUP_COUNT
  target_node  = var.PM_BACKUP_NODES[count.index]
  hostname     = "haproxy-backup${count.index}"
  onboot       = true
  startup      = "order=1"
  ostemplate   = var.LXC_TEMPLATE
  password     = var.LXC_PASSWORD
  unprivileged = true
  cores        = var.CORES
  memory       = var.MEMORY
  searchdomain = var.LOCAL_DOMAIN
  start        = true
  nameserver   = var.NAMESERVER

  tags = local.backup_tags

  // Terraform will crash without rootfs defined
  rootfs {
    storage = var.STORAGE_NAME
    size    = var.STORAGE_SIZE
  }

  network {
    name   = var.INTERFACE_NAME
    bridge = var.BRIDGE_NAME
    ip     = "${var.BACKUP_IPS[count.index]}/${var.CIDR_BLOCK}"
    gw     = var.GATEWAY
  }

  ssh_public_keys = file(var.public_key)
}
