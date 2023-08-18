variable "lxc_count" {
  type        = number
  description = "Number of LXCs to create"
}

variable "target_nodes" {
  type        = list(string)
  description = "List of target nodes for the LXC(s)"
}

variable "hostname" {
  type        = string
  description = "Hostname prefix of the LXC"
}

variable "ostemplate" {
  type        = string
  description = "OS Template for LXC"
}

variable "password" {
  type        = string
  description = "Default password of the clount-init user of the LXC"
  sensitive   = true
}

variable "cores" {
  type        = number
  description = "Number of cores for the LXC"
}

variable "memory" {
  type        = number
  description = "Amount of RAM to give to LXC"
}

variable "searchdomain" {
  type        = string
  description = "DNS Search domain for the LXC"
}

variable "nameserver" {
  type        = string
  description = "DNS server for LXC"
}

variable "tags" {
  type        = string
  description = "Tags for the LXC"
}

variable "storage" {
  type        = string
  description = "Storage backend to use for LXC"
}

variable "size" {
  type        = string
  description = "Size of storage device for LXC"
}

variable "iname" {
  type        = string
  description = "Name of the interface for the LXC"
}

variable "bridge" {
  type        = string
  description = "Name of the bridge to use for LXC"
}

variable "ips" {
  type        = list(string)
  description = "List of IP addresses for the LXC(s)"
}

variable "cidr" {
  type        = number
  description = "CIDR block to use in network"
}

variable "gw" {
  type        = string
  description = "Default gateway for network"
}

variable "public_key" {
  type        = string
  description = "Path to public key for LXC user"
}

variable "startup_order" {
  type        = string
  description = "Order of startup of LXC"
}
