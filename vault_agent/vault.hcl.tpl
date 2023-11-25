vault {
  address = "https://vault.homelab.local"
  ca_cert = "${VAULT_CERT_DIR}/homelab.local-agent-ca.pem"
  retry {
    num_retries = 5
  }
}

auto_auth {

  method {
    type = "approle"

    config = {
      role_id_file_path = "/terraform/vault_agent/roleid"
      secret_id_file_path = "/terraform/vault_agent/secretid"
      remove_secret_id_file_after_reading = false
    }
  }
}

template_config {
  static_secret_render_interval = "1m"
  exit_on_retry_failure         = true
}