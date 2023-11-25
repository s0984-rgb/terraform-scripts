terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.23.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "2.19.0"
    }
  }
}
