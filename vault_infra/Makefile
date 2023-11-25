include ../Makefile

#@ Vault
##@ Certs

vault_ca: _check_domain ## Create Vault CA
	@cd ${VAULT_CERT_DIR} \
		&& nomad tls ca create \
			-common-name "Vault CA" \
			-country "CA" \
			-days 3650 \
			-domain ${DOMAIN} \
			-locality "Montreal" \
			-name-constraint \
			-organization "Homelabs" \
			-organizational-unit "Vault" \
			-province "QC"

vault_server_certs: _check_domain ## Create Vault server certificate
	@cd ${VAULT_CERT_DIR} \
		&& nomad tls cert create -server \
			-days 3650 \
			-domain ${DOMAIN} \
			-additional-dnsname vault0.${DOMAIN} \
			-additional-dnsname vault1.${DOMAIN} \
			-additional-dnsname vault2.${DOMAIN} \
			-additional-dnsname vault.${DOMAIN} \
			-region NCSA

vault_init: ## Initialize vault
	@cd ${VAULT_TOKEN_DIR} \
		&& vault operator init -format json | tee vault_unseal.token

parse_vault_token: ## Export vault bootstrap token
	@echo "export VAULT_TOKEN=$(shell jq '.root_token' < ${VAULT_TOKEN_DIR}/vault_unseal.token)" \
			> ${ENVIRONMENT_DIR}/vault-bootstrap-token.env

unseal_vault: ## Unseal vault with 3 keys
	@vault operator unseal $(shell jq '.unseal_keys_b64[0]' < ../tokens/vault/vault_unseal.token)
	@vault operator unseal $(shell jq '.unseal_keys_b64[1]' < ../tokens/vault/vault_unseal.token)
	@vault operator unseal $(shell jq '.unseal_keys_b64[2]' < ../tokens/vault/vault_unseal.token)

vault_root_ca: _check_domain ## Create Root CA inside Vault
	@cd ${VAULT_CERT_DIR} \
		&& vault secrets enable -path=pki pki \
		&& vault write -field=certificate pki/root/generate/internal \
			common_name="${DOMAIN} Root CA" \
			ttl=87600h \
			allowed_domains=["${DOMAIN}","dc1.consul"] | tee ${DOMAIN}-root-ca.pem

reset_vault: ## Resets vault environment to zero
	@ansible vault -i inventory.ini -m command -b -a "systemctl stop vault"
	@ansible vault -i inventory.ini -m command -b -a "rm -rf /var/lib/vault"
	@ansible vault -i inventory.ini -m command -b -a "rm -rf /etc/vault.d"
