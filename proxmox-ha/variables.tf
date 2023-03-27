#############################
#### API Authentication #####
#############################

variable "PIHOLE_API_KEY" {
  type        = string
  description = "Pihole API to create DNS entries"
  sensitive   = true
}

#############################
######     Proxmox     ######
#############################

variable "PM_MASTER_NODE" {
  type        = string
  description = "Proxmox node that will host the MASTER LXC (e.g. pve1)"
}

variable "PM_BACKUP_NODE" {
  type        = string
  description = "Proxmox node that will host the BACKUP LXC (e.g. pve2)"
}

#############################
######   Netowrking    ######
#############################

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

variable "BACKUP_IP" {
  type        = string
  description = "IP address of the second LXC container"
}

variable "CIDR_BLOCK" {
  type        = string
  description = "CIDR block used for the netowkr (e.g. '24' for /24)"
}

#############################
##### LXC Configuration #####
#############################

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
  default     = "local-lvm"
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
