template {
  source      = "/terraform/vault_agent/templates/nomad.pem.tpl"
  destination = "${NOMAD_CERT_DIR}/nomad.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh nomad ${NOMAD_CERT_DIR}"
}

template {
  source      = "/terraform/vault_agent/templates/nomad-ca.pem.tpl"
  destination = "${NOMAD_CERT_DIR}/nomad-ca.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh nomad ${NOMAD_CERT_DIR}"
}

template {
  source      = "/terraform/vault_agent/templates/consul.pem.tpl"
  destination = "${CONSUL_CERT_DIR}/consul.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh consul ${CONSUL_CERT_DIR}"
}

template {
  source      = "/terraform/vault_agent/templates/consul-ca.pem.tpl"
  destination = "${CONSUL_CERT_DIR}/consul-ca.pem"
  perms = 0644
  left_delimiter  = "{{"
  right_delimiter = "}}"
  command     = "bash /terraform/vault_agent/pfx_script.sh consul ${CONSUL_CERT_DIR}"
}
