SHELL:=/bin/bash
VAULT_CERT_DIR:=../vault_certs
NOMAD_CERT_DIR:=../nomad_certs
CONSUL_CERT_DIR:=../consul_certs
TOKENS_DIR:=tokens
NOMAD_TOKEN_DIR:=${TOKENS_DIR}/nomad
CONSUL_TOKEN_DIR:=${TOKENS_DIR}/consul
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

#@ Nomad

nomad_ca: _check_domain ## Create Nomad CA
	@cd ${NOMAD_CERT_DIR} \
		&& nomad tls ca create \
			-common-name "Nomad CA" \
			-country "CA" \
			-days 3650 \
			-domain ${DOMAIN} \
			-locality "Montreal" \
			-name-constraint \
			-organization "Homelabs" \
			-organizational-unit "Nomad" \
			-province "QC"

nomad_server_certs: _check_domain ## Create Nomad server certificate
	@cd ${NOMAD_CERT_DIR} \
		&& nomad tls cert create -server \
			-days 3650 \
			-domain ${DOMAIN} \
			-region NCSA \
			-additional-dnsname nomad-server0.${DOMAIN} \
			-additional-dnsname nomad-server1.${DOMAIN} \
			-additional-dnsname nomad-server3.${DOMAIN} \
			-additional-dnsname nomad.${DOMAIN}

nomad_client_certs: _check_domain ## Create Nomad client certificate
	@cd ${NOMAD_CERT_DIR} \
		&& nomad tls cert create -client \
			-ca ${DOMAIN}-agent-ca.pem \
			-key ${DOMAIN}-agent-ca-key.pem \
			-days 3650

nomad_cli_certs: _check_domain ## Create Nomad CLI certificate
	@cd ${NOMAD_CERT_DIR} \
		&& nomad tls cert create -cli \
			-ca ${DOMAIN}-agent-ca.pem \
			-key ${DOMAIN}-agent-ca-key.pem \
			-days 3650

nomad_pfx: ## Create PFX file for Nomad certificates (for use in browser)
	@cd ${NOMAD_CERT_DIR} \
		&& openssl pkcs12 -export \
			-keypbe NONE \
			-certpbe NONE \
			-nomaciter \
			-passout pass: \
			-inkey global-client-nomad-key.pem \
			-in global-client-nomad.pem \
			-out client.pfx

##@ ACL
nomad_acl_bootstrap: ## Bootstrap Nomad ACLs
	@cd ${NOMAD_TOKEN_DIR} \
		&& nomad acl bootstrap | tee nomad-bootstrap.token

#@ Consul
##@ Certs
CONSUL_PKI:=pki_consul
# Enable ${CONSUL_PKI} secrets engine
# Tune ${CONSUL_PKI} secrets engine
# Create Consul intermediate CA CSR
# Sign intermediate CA CSR with Vault Root CA
# Set signed intermediate CA certificate
# Create role to generate certificates
consul_ca: _check_domain ## Create Consul CA infrastructure in Vault
	@cd ${CONSUL_CERT_DIR} \
		&& vault secrets enable -path=${CONSUL_PKI} pki \
		&& vault secrets tune -max-lease-ttl=43800h ${CONSUL_PKI} \
		&& vault write -format=json ${CONSUL_PKI}/intermediate/generate/internal \
			common_name="dc1.consul Intermediate Authority" \
			| jq -r '.data.csr' | tee ${CONSUL_PKI}.csr \
		&& vault write -format=json pki/root/sign-intermediate \
			csr=@${CONSUL_PKI}.csr \
        	format=pem_bundle ttl="43800h" \
        	| jq -r '.data.certificate' | tee intermediate.cert.pem \
		&& vault write ${CONSUL_PKI}/intermediate/set-signed \
			certificate=@intermediate.cert.pem \
		&& vault write ${CONSUL_PKI}/roles/consul-dc1 \
			allowed_domains="${DOMAIN}","dc1.consul" \
			allow_subdomains=true \
			generate_lease=true \
			max_ttl="720h"

consul_server_certs: _check_domain ## Create Consul server certificates
	@cd ${CONSUL_CERT_DIR} \
		&& vault write ${CONSUL_PKI}/issue/consul-dc1 \
			common_name="server.dc1.consul" \
			ip_sans="192.168.2.22" \
			alt_names="consul0.${DOMAIN}" \
			ttl="24h" | tee server-certs.txt

# consul_server_certs: _check_domain ## Create Consul server certificates
# 	@cd ${CONSUL_CERT_DIR} \
# 		&& consul tls cert create -server \
# 			-ca ${DOMAIN}-agent-ca.pem \
# 			-key ${DOMAIN}-agent-ca-key.pem \
# 			-additional-ipaddress 192.168.2.22 \
# 			-additional-dnsname consul0.${DOMAIN} \
# 			-additional-dnsname server.dc1.consul \
# 			-days 3650 \
# 			-domain ${DOMAIN}

consul_client_certs: _check_domain ## Create Consult client certificates in Vault
	@cd ${CONSUL_CERT_DIR} \
		&& vault write ${CONSUL_PKI}/issue/consul-dc1 \
			common_name="client.dc1.consul" \
			ttl="720h" \
			-format=json | tee client-certs.json

# consul_client_certs: _check_domain ## Create Consul client certificates
# 	@cd ${CONSUL_CERT_DIR} \
# 		&& consul tls cert create -client \
# 			-ca ${DOMAIN}-agent-ca.pem \
# 			-key ${DOMAIN}-agent-ca-key.pem \
# 			-days 3650

consul_cli_certs: _check_domain ## Create Consul CLI certificates
	@cd ${CONSUL_CERT_DIR} \
		&& consul tls cert create -cli \
			-ca ${DOMAIN}-agent-ca.pem \
			-key ${DOMAIN}-agent-ca-key.pem \
			-domain ${DOMAIN} \
			-days 3650

consul_pfx: _check_domain ## Create PFX file for Consul certificates (for use in browser)
	@cd ${CONSUL_CERT_DIR} \
		&& openssl pkcs12 -export \
			-keypbe NONE \
			-certpbe NONE \
			-nomaciter \
			-passout pass: \
			-inkey dc1-cli-${DOMAIN}-0-key.pem \
			-in dc1-cli-${DOMAIN}-0.pem \
			-out client.pfx

##@ ACL
consul_acl_bootstrap: ## Bootstrap Consul ACLs
	@cd ${CONSUL_TOKEN_DIR} \
		&& consul acl bootstrap | tee consul-bootstrap.token

consul_secret_engine: ## Create Consul secret engine in Vault
	@vault secrets enable -path=consul/ consul
	@vault write consul/config/access address=${CONSUL_HTTP_ADDR} \
		scheme=https \
		token=${CONSUL_HTTP_TOKEN} \
		ca_cert="`cat ${CONSUL_CACERT}`" \
		client_cert="`cat ${CONSUL_CLIENT_CERT}`" \
		client_key="`cat ${CONSUL_CLIENT_KEY}`"

consul_acl_consul_server_policy: ## Create Consul server policy
	@cd ${CONSUL_TOKEN_DIR} \
		&& consul acl policy create \
			-name consul-server \
			-rules @consul-server-policy.hcl \
		&& vault write consul/roles/consul-server-role \
			policies=consul-server

consul_acl_consul_client_policy: ## Create Consul client policy
	@cd ${CONSUL_TOKEN_DIR} \
		&& consul acl policy create \
			-name consul-client \
			-rules @consul-client-policy.hcl \
		&& vault write consul/roles/consul-client-role \
			policies=consul-client

consul_acl_server_token: ## Create Consul ACL server token
	@cd ${CONSUL_TOKEN_DIR} \
		&& vault read consul/creds/consul-server-role | tee consul-server.token

consul_acl_client_token: ## Create Consul ACL client token
	@cd ${CONSUL_TOKEN_DIR} \
		&& vault read consul/creds/consul-client-role | tee consul-client.token

consul_acl_nomad_server_policy: ## Create Nomad server ACLs in Consul
	@cd ${CONSUL_TOKEN_DIR} \
		&& consul acl policy create \
			-name "nomad-server" \
			-description "Nomad Server Policy" \
			-rules @nomad-server-policy.hcl \
		&& vault write consul/roles/nomad-server-role \
			policies=nomad-client,nomad-server

consul_acl_nomad_client_policy: ## Create Nomad client ACLs in Consul
	@cd ${CONSUL_TOKEN_DIR} \
		&& consul acl policy create \
			-name "nomad-client" \
			-description "Nomad Client Policy" \
			-rules @nomad-client-policy.hcl \
		&& vault write consul/roles/nomad-client-role \
			policies=nomad-client,nomad-server

consul_acl_nomad_server_token: ## Create Nomad Server token in Consul
	@cd ${CONSUL_TOKEN_DIR} \
		&& vault read consul/creds/nomad-server-role | tee nomad-server.token

consul_acl_nomad_client_token: ## Create Nomad token in Consul
	@cd ${CONSUL_TOKEN_DIR} \
		&& vault read consul/creds/nomad-client-role | tee nomad-client.token

# consul_acl_nomad_token: ## Create Nomad token in Consul
# 	@cd ${CONSUL_TOKEN_DIR} \
# 		&& consul acl token create \
# 			-description "Nomad Agent Token" \
# 			-policy-name "nomad-server" \
# 			-policy-name "nomad-client" | tee nomad-agent.token

# consul_acl_consul_client_token: ## Create Consul client ACL token
# 	@cd ${CONSUL_TOKEN_DIR} \
# 		&& consul acl token create \
# 			-node-identity "consul-client:dc1" \
# 			-description "consul-client token" | tee consul-client.token
