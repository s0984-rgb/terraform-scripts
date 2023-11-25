resource "null_resource" "ssh-add" {
  depends_on = [
    module.docker,
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

resource "null_resource" "docker-server-playbook" {
  depends_on = [
    null_resource.ssh-add
  ]

  # Always run this resource
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini ../playbooks/keycloak.yml"
  }
}
