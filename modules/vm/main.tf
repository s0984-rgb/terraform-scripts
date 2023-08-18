resource "proxmox_vm_qemu" "compute" {
  lifecycle {
    ignore_changes = [disk, network, qemu_os]
  }
  os_type          = "cloud-init"
  count            = var.COUNT
  target_node      = var.TARGET_NODES[count.index % length(var.TARGET_NODES)]
  name             = "${var.NAME}${count.index}"
  automatic_reboot = true
  onboot           = true
  startup          = "order=1"
  clone            = var.CLONE_NAME
  full_clone       = true
  cores            = var.CORES
  memory           = var.MEMORY
  tags             = var.TAGS
  scsihw           = "virtio-scsi-pci"
  ciuser           = var.CIUSER
  cipassword       = var.CIPASSWD
  sshkeys          = file(var.public_key)
  ipconfig0        = "ip=${var.IPS[count.index]}${var.CIDR},gw=${var.GATEWAY}"
  nameserver       = var.NAMESERVER
  searchdomain     = var.LOCAL_DOMAIN
}

resource "pihole_dns_record" "compute" {
  depends_on = [
    proxmox_vm_qemu.compute
  ]
  count  = var.COUNT
  domain = "${var.NAME}${count.index}.${var.LOCAL_DOMAIN}"
  ip     = var.IPS[count.index]
}