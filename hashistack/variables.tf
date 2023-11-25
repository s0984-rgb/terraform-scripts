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

// Vault

variable "VAULT_ADDR" {
  type        = string
  description = "Address for Vault server"
}

variable "VAULT_TOKEN" {
  type        = string
  description = "Token to authenticate against Vault server"
}

variable "VAULT_CACERT" {
  type        = string
  description = "CA certificate for Vault server"
}

variable "VAULT_APPROLE_ID" {
  type        = string
  description = "Vault Approle role ID"
}

variable "VAULT_APPROLE_SECRET" {
  type        = string
  description = "Vault Approle role secret"
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

// SERVER

variable "SERVER_COUNT" {
  type        = number
  description = "Number of servers to spawn"
}

variable "TARGET_SERVER_NODES" {
  type        = list(string)
  description = "Target nodes for the controller node"
}

variable "SERVER_NAME" {
  type        = string
  description = "Hostname for the controller node"
}

variable "SERVER_CORES" {
  type        = number
  description = "Number of cores for the LXC container"
}

variable "SERVER_MEMORY" {
  type        = number
  description = "Memory of the LXC container"
}

variable "SERVER_IPS" {
  type        = list(string)
  description = "IP address of the server node"
}

variable "SERVER_TAGS" {
  type        = string
  description = "Tags for the server node"
}

variable "NOMAD_SERVER_GOSSIP_KEY" {
  type        = string
  description = "Gossip encryption key for the servers"
  sensitive   = true
}

variable "CONSUL_SERVER_GOSSIP_KEY" {
  type        = string
  description = "Gossip encryption key for the servers"
  sensitive   = true
}

// Client

variable "TARGET_CLIENT_NODES" {
  type        = list(any)
  description = "List of target nodes for compute nodes"
}

variable "CLIENT_CORES" {
  type        = number
  description = "Number of cores for the LXC container"
}

variable "CLIENT_MEMORY" {
  type        = number
  description = "Memory of the LXC container"
}

variable "CLIENT_COUNT" {
  type        = number
  description = "Number of compute nodes in your cluster"
}

variable "CLIENT_IPS" {
  type        = list(any)
  description = "List of IP addresses for compute nodes"
}

variable "CLIENT_NAME" {
  type        = string
  description = "Default name of the client nodes"
}

variable "CLIENT_TAGS" {
  type        = string
  description = "Tags for the client nodes"
}

// Consul

variable "TARGET_CONSUL_NODES" {
  type        = list(any)
  description = "List of target nodes for compute nodes"
}

variable "CONSUL_CORES" {
  type        = number
  description = "Number of cores for the LXC container"
}

variable "CONSUL_MEMORY" {
  type        = number
  description = "Memory of the LXC container"
}

variable "CONSUL_COUNT" {
  type        = number
  description = "Number of compute nodes in your cluster"
}

variable "CONSUL_IPS" {
  type        = list(any)
  description = "List of IP addresses for compute nodes"
}

variable "CONSUL_NAME" {
  type        = string
  description = "Default name of the client nodes"
}

variable "CONSUL_TAGS" {
  type        = string
  description = "Tags for the client nodes"
}
