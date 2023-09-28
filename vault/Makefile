SHELL:=/bin/bash
VAULT_CERT_DIR:=../vault_certs
TOKENS_DIR:=tokens
VAULT_TOKEN_DIR:=${TOKENS_DIR}/vault

_check_domain:
ifndef DOMAIN
DOMAIN:=homelab.local
endif

help: ## Show this help
	@echo "----------------------------------------------------------------------"
	@echo "Descriptions of Make commands and what they do."
	@echo "Usage: $(MAKE) <cmd1> <cmd2> <cmdN>"
	@echo "e.g.: $(MAKE) help"
	@echo "----------------------------------------------------------------------"
	@sed -ne 's/^\([^[:space:]]*\):.*##/\1:\t/p' $(MAKEFILE_LIST) | column -t -s $$'\t'

#@ Vault
##@ Certs
init: ## Create base directories
	@mkdir -p ${VAULT_TOKEN_DIR}

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
			-region NCSA

vault_init: ## Initialize vault
	@cd ${VAULT_TOKEN_DIR} \
		&& vault operator init | tee vault_unseal.token

vault_root_ca: _check_domain ## Create Root CA inside Vault
	@cd ${VAULT_CERT_DIR} \
		&& vault secrets enable -path=pki pki \
		&& vault write -field=certificate pki/root/generate/internal \
			common_name="${DOMAIN} Root CA" \
			ttl=87600h \
			allowed_domains=["${DOMAIN}","dc1.consul"] | tee ${DOMAIN}-root-ca.pem