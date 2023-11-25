terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.22.0"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.0.0"
    }
  }
}
