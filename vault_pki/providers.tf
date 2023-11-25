terraform {
  backend "local" {}
}

provider "vault" {
  # Configuration options
  address = var.VAULT_ADDR
  token   = var.VAULT_TOKEN
}
