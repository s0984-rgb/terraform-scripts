include ../Makefile

#@ Nomad
nomad_ca: _check_domain ## Create Nomad CA
	@cd ${NOMAD_CERT_DIR}
	@vault secrets enable -path=${NOMAD_PKI} pki
	@vault secrets tune -max-lease-ttl=43800h ${NOMAD_PKI}
	@vault write -format=json ${NOMAD_PKI}/intermediate/generate/internal \
		common_name="dc1.nomad Intermediate Authority" \
		| jq -r '.data.csr' | tee ${NOMAD_CSR}
	@vault write -format=json pki/root/sign-intermediate \
		csr=@${NOMAD_CSR} \
		format=pem_bundle ttl="43800h" \
		| jq -r '.data.certificate' | tee ${NOMAD_INT_CERT}
	@vault write ${NOMAD_PKI}/intermediate/set-signed \
		certificate=@${NOMAD_INT_CERT}
	@vault write ${NOMAD_PKI}/roles/nomad-dc1 \
		allowed_domains="${DOMAIN}","dc1.nomad" \
		allow_subdomains=true \
		generate_lease=true \
		max_ttl="720h"

##@ ACL
nomad_acl_bootstrap: ## Bootstrap Nomad ACLs
	@echo "export NOMAD_TOKEN=$(shell nomad acl bootstrap -json | jq -r '.SecretID')" \
			> ${ENVIRONMENT_DIR}/nomad-bootstrap-token.env

#@ Consul
##@ Certs
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

##@ ACL
consul_acl_bootstrap: ## Bootstrap Consul ACLs
	@echo "export CONSUL_HTTP_TOKEN=$(shell consul acl bootstrap -format=json | jq -r '.SecretID')" \
			> ${ENVIRONMENT_DIR}/consul-bootstrap-token.env

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

get_vault_agent_approle_id: ## Retrieve consul approle id
	@cd ${ENVIRONMENT_DIR} \
		&& echo "export TF_VAR_VAULT_APPROLE_ID=$(shell vault read auth/approle/role/vault-agent/role-id -format=json | jq '.data.role_id')" \
			> vault_approle_id.env

get_vault_agent_approle_secret: ## Retrieve consul approle secret
	@cd ${ENVIRONMENT_DIR} \
		&& echo "export TF_VAR_VAULT_APPROLE_SECRET=$(shell vault write -f auth/approle/role/vault-agent/secret-id -format=json | jq '.data.secret_id')" \
			> vault_approle_secret.env

# vault_agent_token_policy: ## Create token policy for vault agent
# 	@vault policy write token policies/token.hcl

# vault_agent_consul_policy: ## Create Consul policy for vault agent
# 	@vault policy write consul policies/consul.hcl

# vault_agent_nomad_policy: ## Create Nomad policy for vault agent
# 	@vault policy write nomad policies/nomad.hcl

# vault_agent_policies: ## Create all policies for vault agent
# 	@$(MAKE) vault_agent_token_policies vault_agent_consul_policies vault_agent_nomad_policies

# vault_agent_enable_approle: ## Enable approle authentication method on Vault
# 	@vault enable auth approle

# vault_agent_approle: ## Create Consul approle role and associate policies
# 	@vault write auth/approle/role/vault-agent \
# 		policies="token","consul","nomad"

wipe_consul_environment: ## Stop vault agent, consul, and nomad and delete all config and data directories
	@ansible consul -i inventory.ini -m command -b -a "systemctl stop vault-agent"
	@ansible consul -i inventory.ini -m command -b -a "systemctl stop consul"
	@ansible consul -i inventory.ini -m command -b -a "rm -rf /var/lib/vault"
	@ansible consul -i inventory.ini -m command -b -a "rm -rf /var/lib/consul"
	@ansible consul -i inventory.ini -m command -b -a "rm -rf /etc/consul.d"
	@ansible consul -i inventory.ini -m command -b -a "rm -rf /etc/vault.d"

wipe_nomad_environment: ## Stop vault agent, consul, and nomad and delete all config and data directories
	@ansible nomad-server -i inventory.ini -m command -b -a "systemctl stop vault-agent"
	@ansible nomad-server -i inventory.ini -m command -b -a "systemctl stop consul"
	@ansible nomad-server -i inventory.ini -m command -b -a "systemctl stop nomad"
	@ansible nomad-server -i inventory.ini -m command -b -a "rm -rf /var/lib/vault"
	@ansible nomad-server -i inventory.ini -m command -b -a "rm -rf /var/lib/consul"
	@ansible nomad-server -i inventory.ini -m command -b -a "rm -rf /var/lib/nomad"
	@ansible nomad-server -i inventory.ini -m command -b -a "rm -rf /etc/nomad.d"
	@ansible nomad-server -i inventory.ini -m command -b -a "rm -rf /etc/consul.d"
	@ansible nomad-server -i inventory.ini -m command -b -a "rm -rf /etc/vault.d"
	@ansible nomad-client -i inventory.ini -m command -b -a "systemctl stop vault-agent"
	@ansible nomad-client -i inventory.ini -m command -b -a "systemctl stop consul"
	@ansible nomad-client -i inventory.ini -m command -b -a "systemctl stop nomad"
	@ansible nomad-client -i inventory.ini -m command -b -a "rm -rf /var/lib/vault"
	@ansible nomad-client -i inventory.ini -m command -b -a "rm -rf /var/lib/consul"
	@ansible nomad-client -i inventory.ini -m command -b -a "rm -rf /var/lib/nomad"
	@ansible nomad-client -i inventory.ini -m command -b -a "rm -rf /etc/nomad.d"
	@ansible nomad-client -i inventory.ini -m command -b -a "rm -rf /etc/consul.d"
	@ansible nomad-client -i inventory.ini -m command -b -a "rm -rf /etc/vault.d"
	
restart_vault_agent: ## Restart vault-agent service on nomad machines
	@ansible nomad-server -i inventory.ini -m command -b -a "systemctl restart vault-agent"
	@ansible nomad-client -i inventory.ini -m command -b -a "systemctl restart vault-agent"

restart_nomad: ## Restart nomad service
	@ansible nomad-server -i inventory.ini -m command -b -a "systemctl restart nomad"
	@ansible nomad-client -i inventory.ini -m command -b -a "systemctl restart nomad"

restart_consul_clients: ## Restart consul service on nomad machines
	@ansible nomad-server -i inventory.ini -m command -b -a "systemctl restart consul"
	@ansible nomad-client -i inventory.ini -m command -b -a "systemctl restart consul"

restart_consul_vault_agent:
	@ansible consul -i inventory.ini -m command -b -a "systemctl restart vault-agent"

restart_consul_servers:
	@ansible consul -i inventory.ini -m command -b -a "systemctl restart consul"
