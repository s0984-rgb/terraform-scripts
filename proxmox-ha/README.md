# Introduction

This script addresses the need to provide a high availability entrypoint into a multinode Proxmox cluster.
This is something not offered "out of the box" by Proxmox

This simple terraform script creates 2 LXC containers spread accross 2 nodes in a Proxmox cluster

These Debian based LXC containers run keepalived and HAproxy to provide a single HA entrypoint to the Proxmox cluster

## Before we begin

In order to use these scripts you will require a few things:

- A multinode Proxmox cluster with DNS entries created for each Proxmox host
- An account provisioned with necessary permissions in Proxmox as per the [provider instructions](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
- A Debian based LXC container to pass to this script this script
  - This script has been tested on the image `ubuntu-22.04-standard_22.04-1_amd64` downloadable from Proxmox providers
- A private and public ssh key found at `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` respectively
- At least 3 free IP addresses in your network
  - 1 for the MASTER haproxy, 1 for the BACKUP haproxy and 1 floating IP between the 2 LXCs
- A [pihole](https://pi-hole.net/) configured as your local DNS for your network, with an A record `pihole.<LOCAL_DOMAIN>` pointing to the IP address of your pihole 

example:
```bash
pihole.example.local A 192.168.0.2
```

See the [Terraform Docs](TERRAFORMDOCS.MD) for more information about the resources and variables used in the scripts

## Getting Started

This project uses `direnv`.

1) Copy the file `.env/proxmox.env.dist` and rename it `.env/proxmox.env`
2) Follow the [instructions](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) to configure Proxmox with the necessary roles, users, permissions, and configure your API token
3) Retrieve the root API token from Pihole
4) Configure `.env/proxmox.env` with the values for your setup
5) Configure `terraform.tfvars` in this directory to pass to Terraform
5) Run the `terraform init`, `plan` and `apply` commands

## Results

You will end up with an ingress `pve.your_local_domain` that will be redirected to a virtual IP shared between both LXC containers in a MASTER/BACKUP configuration.

## Adendum

It is possible to create multiple BACKUP LXCs however this script only creates 2 small LXCs for loadbalancing

To do this, you can simply add a `count` parameter to the BACKUP LXC resource definition. For a small homelab setup, 2 LXCs should suffice.
