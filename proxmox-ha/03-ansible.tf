resource "null_resource" "ssh-add" {
  depends_on = [
    proxmox_lxc.haproxy_master,
    proxmox_lxc.haproxy_backup,
    local_file.ansible_inventory
  ]

  # Always run this resource
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "echo -n ${var.private_key_password} | SSH_ASKPASS=/bin/cat setsid -w ssh-add ${var.private_key}" # Add ssh key
  }
}

# Run playbooks

resource "null_resource" "keepalived-playbook" {
  depends_on = [
    proxmox_lxc.haproxy_master,
    proxmox_lxc.haproxy_backup,
    local_file.ansible_inventory,
    null_resource.ssh-add
  ]

  # Always run this resource
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini --extra-vars virtual_ip=${var.VIRTUAL_IP} ../playbooks/keepalived.yml"
  }
}

resource "null_resource" "haproxy-playbook" {
  depends_on = [
    null_resource.keepalived-playbook
  ]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini --extra-vars virtual_ip=${var.VIRTUAL_IP} ../playbooks/haproxy.yml"
  }
}
