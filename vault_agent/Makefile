include ../Makefile

template_vault_agent:  ## Substitute variables for environment varibles in vault agent configs
	@< nomad-consul-template.hcl.tpl envsubst > nomad-consul-template.hcl
	@< vault.hcl.tpl envsubst > vault.hcl

template_credentials:
	@< roleid.tpl envsubst > roleid
	@< secretid.tpl envsubst > secretid