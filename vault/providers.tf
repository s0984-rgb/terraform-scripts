provider "proxmox" {
  # Configuration options
  pm_api_url = var.proxmox_endpoint
}

provider "pihole" {
  url       = var.pihole_url     # PIHOLE_URL
  api_token = var.pihole_api_key # PIHOLE_API_TOKEN
}

terraform {
  backend "local" {}
}
