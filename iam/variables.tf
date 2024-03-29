// API Authentication
variable "pihole_api_key" {
  type        = string
  description = "Pihole API Key to create DNS entries"
  sensitive   = true
}

variable "pihole_url" {
  type        = string
  description = "Pihole API URL"
}

// Proxmox
variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API endpoint"
}

variable "proxmox_url" {
  type        = string
  description = "DNS entry for proxmox HA"
}

variable "PM_MASTER_NODE" {
  type        = string
  description = "Proxmox node that will host the MASTER LXC (e.g. pve1)"
}

variable "PM_BACKUP_NODES" {
  type        = list(string)
  description = "List of proxmox node(s) that will host the BACKUP LXC(s) (e.g. [\"pve2\", \"pve3\"])"
}

// GENERAL

variable "CLONE_NAME" {
  type        = string
  description = "Name of the VM to clone"
}

variable "LOCAL_DOMAIN" {
  type        = string
  description = "Local domain of the network"
}

variable "NAMESERVER" {
  type        = string
  description = "Nameserver IP address"
}

variable "GATEWAY" {
  type        = string
  description = "Default gateway of the network"
}

variable "CIDR" {
  type        = string
  description = "CIDR block of the network"
  default     = "/24"
}

variable "CIUSER" {
  type        = string
  description = "cloud-init user"
}

variable "CIPASSWD" {
  type        = string
  description = "cloud-init password"
  sensitive   = true
}

variable "private_key" {
  type        = string
  description = "Private key to use to ssh into LXC"
}

variable "public_key" {
  type        = string
  description = "Public key to copy onto LXC"
}

variable "private_key_password" {
  type        = string
  description = "Private key password"
  sensitive   = true
}

// Consul

variable "TARGET_DOCKER_NODES" {
  type        = list(any)
  description = "List of target nodes for compute nodes"
}

variable "DOCKER_CORES" {
  type        = number
  description = "Number of cores for the LXC container"
}

variable "DOCKER_MEMORY" {
  type        = number
  description = "Memory of the LXC container"
}

variable "DOCKER_COUNT" {
  type        = number
  description = "Number of compute nodes in your cluster"
}

variable "DOCKER_IPS" {
  type        = list(any)
  description = "List of IP addresses for compute nodes"
}

variable "DOCKER_NAME" {
  type        = string
  description = "Default name of the client nodes"
}

variable "DOCKER_TAGS" {
  type        = string
  description = "Tags for the client nodes"
}
