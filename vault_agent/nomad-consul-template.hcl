template {
  source      = "/terraform/vault_agent/templates/nomad.pem.tpl"
  destination = "/terraform/certs/nomad/nomad.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh nomad /terraform/certs/nomad"
}

template {
  source      = "/terraform/vault_agent/templates/nomad-ca.pem.tpl"
  destination = "/terraform/certs/nomad/nomad-ca.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh nomad /terraform/certs/nomad"
}

template {
  source      = "/terraform/vault_agent/templates/consul.pem.tpl"
  destination = "/terraform/certs/consul/consul.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh consul /terraform/certs/consul"
}

template {
  source      = "/terraform/vault_agent/templates/consul-ca.pem.tpl"
  destination = "/terraform/certs/consul/consul-ca.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh consul /terraform/certs/consul"
}
