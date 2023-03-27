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

  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  provisioner "file" {
    destination = "/tmp/setup.sh"
    content = templatefile("${path.module}/templates/setup.sh.tftpl", {
      INTERFACE      = "${proxmox_lxc.haproxy_master.network[0].name}"
      ROLE           = "MASTER"
      PRIORITY       = 101
      VIRTUAL_ROUTER = "51"
      VIRTUAL_IP     = var.VIRTUAL_IP
    })
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.MASTER_IP
      private_key = file("~/.ssh/id_rsa")
    }
  }

  provisioner "remote-exec" {
    inline = ["bash /tmp/setup.sh"]
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.MASTER_IP
      private_key = file("~/.ssh/id_rsa")
    }
  }
}

resource "proxmox_lxc" "haproxy_backup" {
  target_node  = var.PM_BACKUP_NODE
  hostname     = "haproxy-backup"
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
    ip     = "${var.BACKUP_IP}/${var.CIDR_BLOCK}"
    gw     = var.GATEWAY
  }

  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  provisioner "file" {
    destination = "/tmp/setup.sh"
    content = templatefile("${path.module}/templates/setup.sh.tftpl", {
      INTERFACE      = "${proxmox_lxc.haproxy_backup.network[0].name}"
      ROLE           = "BACKUP"
      PRIORITY       = 100
      VIRTUAL_ROUTER = "51"
      VIRTUAL_IP     = var.VIRTUAL_IP
    })
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.BACKUP_IP
      private_key = file("~/.ssh/id_rsa")
    }
  }

  provisioner "remote-exec" {
    inline = ["bash /tmp/setup.sh"]
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.BACKUP_IP
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
