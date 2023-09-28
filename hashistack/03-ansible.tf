resource "null_resource" "ssh-add" {
  depends_on = [
    module.consul,
    module.nomad_client,
    module.nomad_server,
    local_file.ansible_inventory,
    local_file.ansible_variables
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

resource "null_resource" "consul-server-playbook" {
  depends_on = [
    null_resource.ssh-add
  ]

  # Always run this resource
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini -e @variables.yml ../playbooks/consul.yml"
  }
}

resource "null_resource" "nomad-server-playbook" {
  depends_on = [
    null_resource.consul-server-playbook
  ]

  # Always run this resource
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini -e @variables.yml ../playbooks/nomad-server.yml"
  }
}

resource "null_resource" "nomad-client-playbook" {
  depends_on = [
    null_resource.nomad-server-playbook
  ]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini -e @variables.yml ../playbooks/nomad-client.yml"
  }
}
