SHELL:=/bin/bash
CONSUL_PKI:=pki_consul
NOMAD_PKI:=pki_nomad

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

source_bash: ## Reload bashrc
	@source ${HOME}/.bashrc

init: ## Create base directories
	@mkdir -p ${VAULT_TOKEN_DIR} ${CONSUL_TOKEN_DIR} ${NOMAD_TOKEN_DIR} ${VAULT_CERT_DIR} ${CONSUL_CERT_DIR} ${NOMAD_CERT_DIR}
