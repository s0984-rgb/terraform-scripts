module "consul" {
  source       = "../modules/vm"
  CLONE_NAME   = var.CLONE_NAME
  LOCAL_DOMAIN = var.LOCAL_DOMAIN
  NAMESERVER   = var.NAMESERVER
  GATEWAY      = var.GATEWAY
  CIDR         = var.CIDR
  CIUSER       = var.CIUSER
  CIPASSWD     = var.CIPASSWD
  public_key   = var.public_key
  COUNT        = var.CONSUL_COUNT
  TARGET_NODES = var.TARGET_CONSUL_NODES
  NAME         = var.CONSUL_NAME
  CORES        = var.CONSUL_CORES
  MEMORY       = var.CONSUL_MEMORY
  TAGS         = var.CONSUL_TAGS
  IPS          = var.CONSUL_IPS
}

module "nomad_server" {
  depends_on   = [module.consul]
  source       = "../modules/vm"
  CLONE_NAME   = var.CLONE_NAME
  LOCAL_DOMAIN = var.LOCAL_DOMAIN
  NAMESERVER   = var.NAMESERVER
  GATEWAY      = var.GATEWAY
  CIDR         = var.CIDR
  CIUSER       = var.CIUSER
  CIPASSWD     = var.CIPASSWD
  public_key   = var.public_key
  COUNT        = var.SERVER_COUNT
  TARGET_NODES = var.TARGET_SERVER_NODES
  NAME         = var.SERVER_NAME
  CORES        = var.SERVER_CORES
  MEMORY       = var.SERVER_MEMORY
  TAGS         = var.SERVER_TAGS
  IPS          = var.SERVER_IPS
}

module "nomad_client" {
  depends_on   = [module.nomad_server]
  source       = "../modules/vm"
  CLONE_NAME   = var.CLONE_NAME
  LOCAL_DOMAIN = var.LOCAL_DOMAIN
  NAMESERVER   = var.NAMESERVER
  GATEWAY      = var.GATEWAY
  CIDR         = var.CIDR
  CIUSER       = var.CIUSER
  CIPASSWD     = var.CIPASSWD
  public_key   = var.public_key
  COUNT        = var.CLIENT_COUNT
  TARGET_NODES = var.TARGET_CLIENT_NODES
  NAME         = var.CLIENT_NAME
  CORES        = var.CLIENT_CORES
  MEMORY       = var.CLIENT_MEMORY
  TAGS         = var.CLIENT_TAGS
  IPS          = var.CLIENT_IPS
}
