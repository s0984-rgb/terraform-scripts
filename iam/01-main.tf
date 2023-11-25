module "docker" {
  source       = "../modules/vm"
  CLONE_NAME   = var.CLONE_NAME
  LOCAL_DOMAIN = var.LOCAL_DOMAIN
  NAMESERVER   = var.NAMESERVER
  GATEWAY      = var.GATEWAY
  CIDR         = var.CIDR
  CIUSER       = var.CIUSER
  CIPASSWD     = var.CIPASSWD
  public_key   = var.public_key
  COUNT        = var.DOCKER_COUNT
  TARGET_NODES = var.TARGET_DOCKER_NODES
  NAME         = var.DOCKER_NAME
  CORES        = var.DOCKER_CORES
  MEMORY       = var.DOCKER_MEMORY
  TAGS         = var.DOCKER_TAGS
  IPS          = var.DOCKER_IPS
}

resource "pihole_dns_record" "keycloak" {
  depends_on = [
    module.docker
  ]
  domain = "keycloak.homelab.local"
  ip     = var.DOCKER_IPS[0]
}
