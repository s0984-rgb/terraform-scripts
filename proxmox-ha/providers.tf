provider "proxmox" {
  # Configuration options
  pm_api_url = "https://${var.PM_MASTER_NODE}.${var.LOCAL_DOMAIN}:8006/api2/json"
}

provider "pihole" {
  url       = "http://pihole.${var.LOCAL_DOMAIN}" # PIHOLE_URL
  api_token = var.PIHOLE_API_KEY                  # PIHOLE_API_TOKEN
}

terraform {
  backend "local" {}
}
