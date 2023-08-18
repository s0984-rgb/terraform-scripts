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

variable "public_key" {
  type        = string
  description = "Public key to copy onto LXC"
}

variable "COUNT" {
  type        = number
  description = "Number of machines to create"
}

variable "TARGET_NODES" {
  type        = list(string)
  description = "List of target nodes of compute"
}

variable "NAME" {
  type        = string
  description = "Name prefix of the compute instance"
}

variable "CORES" {
  type        = number
  description = "Number of virtual cores to assign to compute instance"
}

variable "MEMORY" {
  type        = number
  description = "Memory in MiB for the compute instance"
}

variable "TAGS" {
  type        = string
  description = "List of tags for the compute instance"
}

variable "IPS" {
  type        = list(string)
  description = "List of IP addresses to use for compute instances"
}
