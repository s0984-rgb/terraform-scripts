module "vault" {
  source       = "../modules/vm"
  CLONE_NAME   = var.CLONE_NAME
  LOCAL_DOMAIN = var.LOCAL_DOMAIN
  NAMESERVER   = var.NAMESERVER
  GATEWAY      = var.GATEWAY
  CIDR         = var.CIDR
  CIUSER       = var.CIUSER
  CIPASSWD     = var.CIPASSWD
  public_key   = var.public_key
  COUNT        = var.VAULT_COUNT
  TARGET_NODES = var.TARGET_VAULT_NODES
  NAME         = var.VAULT_NAME
  CORES        = var.VAULT_CORES
  MEMORY       = var.VAULT_MEMORY
  TAGS         = var.VAULT_TAGS
  IPS          = var.VAULT_IPS
}
