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

  // Template node setup script
  provisioner "file" {
    destination = "/tmp/setup.sh"
    content = templatefile("${path.module}/templates/setup.sh.tftpl", {
      INTERFACE       = "${proxmox_lxc.haproxy_master.network[0].name}"
      ROLE            = "MASTER"
      PRIORITY        = 200
      VIRTUAL_ROUTER  = "51"
      VIRTUAL_IP      = var.VIRTUAL_IP
      LOCAL_DOMAIN    = var.LOCAL_DOMAIN
      PM_MASTER_NODE  = var.PM_MASTER_NODE
      PM_BACKUP_NODES = var.PM_BACKUP_NODES
    })
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.MASTER_IP
      private_key = file("~/.ssh/id_rsa")
    }
  }

  // Execute script
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
  count        = var.BACKUP_COUNT
  target_node  = var.PM_BACKUP_NODES[count.index]
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
    ip     = "${var.BACKUP_IPS[count.index]}/${var.CIDR_BLOCK}"
    gw     = var.GATEWAY
  }

  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  // Template node setup script
  provisioner "file" {
    destination = "/tmp/setup.sh"
    content = templatefile("${path.module}/templates/setup.sh.tftpl", {
      INTERFACE       = "${proxmox_lxc.haproxy_backup[count.index].network[0].name}"
      ROLE            = "BACKUP"
      PRIORITY        = "10${count.index}"
      VIRTUAL_ROUTER  = "51"
      VIRTUAL_IP      = var.VIRTUAL_IP
      LOCAL_DOMAIN    = var.LOCAL_DOMAIN
      PM_MASTER_NODE  = var.PM_MASTER_NODE
      PM_BACKUP_NODES = var.PM_BACKUP_NODES
    })
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.BACKUP_IPS[count.index]
      private_key = file("~/.ssh/id_rsa")
    }
  }

  // Execute script
  provisioner "remote-exec" {
    inline = ["bash /tmp/setup.sh"]
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.BACKUP_IPS[count.index]
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
