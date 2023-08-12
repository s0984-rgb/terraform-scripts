// API Authentication
variable "PIHOLE_API_KEY" {
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

// Netowrking
variable "VIRTUAL_IP" {
  type        = string
  description = "Virtual IP to assign to Proxmox keepalived"
}

variable "LOCAL_DOMAIN" {
  type        = string
  description = "Local domain of the network"
}

variable "NAMESERVER" {
  type        = string
  description = "Nameserver IP address"
}

variable "INTERFACE_NAME" {
  type        = string
  description = "Default interface name of instance"
  default     = "eth0"
}

variable "BRIDGE_NAME" {
  type        = string
  description = "Default interface name of instance"
  default     = "vmbr0"
}

variable "GATEWAY" {
  type        = string
  description = "Default gateway of the network"
}

variable "MASTER_IP" {
  type        = string
  description = "IP address of the first LXC container"
}

variable "BACKUP_IPS" {
  type        = list(string)
  description = "List of IP addresses for the backup LXC container(s)"
}

variable "CIDR_BLOCK" {
  type        = string
  description = "CIDR block used for the netowkr (e.g. '24' for /24)"
}

// LXC Configuration
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

variable "LXC_TEMPLATE" {
  type        = string
  description = "Location of the LXC template to use for the container"
}

variable "LXC_PASSWORD" {
  type        = string
  description = "Default password for the LXC"
  sensitive   = true
}

variable "STORAGE_NAME" {
  type        = string
  description = "Storage of the disk space for LXC"
}

variable "STORAGE_SIZE" {
  type        = string
  description = "Storage size of the disk for LXC"
  default     = "8G"
}

variable "MEMORY" {
  type        = number
  description = "Memory of the LXC container"
  default     = 256
}

variable "CORES" {
  type        = number
  description = "Number of cores for the LXC container"
  default     = 1
}

variable "BACKUP_COUNT" {
  type        = number
  description = "Number of BACKUP LXC containers"
}
