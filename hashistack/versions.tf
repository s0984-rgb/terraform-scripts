terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.0.12"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.19.0"
    }
  }
}
