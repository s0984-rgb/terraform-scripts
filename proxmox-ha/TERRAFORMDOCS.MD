## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_pihole"></a> [pihole](#requirement\_pihole) | 0.0.12 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 2.9.14 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_pihole"></a> [pihole](#provider\_pihole) | 0.0.12 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.14 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [pihole_dns_record.pve_record](https://registry.terraform.io/providers/ryanwholey/pihole/0.0.12/docs/resources/dns_record) | resource |
| [proxmox_lxc.haproxy_backup](https://registry.terraform.io/providers/Telmate/proxmox/2.9.14/docs/resources/lxc) | resource |
| [proxmox_lxc.haproxy_master](https://registry.terraform.io/providers/Telmate/proxmox/2.9.14/docs/resources/lxc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_BACKUP_IP"></a> [BACKUP\_IP](#input\_BACKUP\_IP) | IP address of the second LXC container | `string` | n/a | yes |
| <a name="input_BRIDGE_NAME"></a> [BRIDGE\_NAME](#input\_BRIDGE\_NAME) | Default interface name of instance | `string` | `"vmbr0"` | no |
| <a name="input_CIDR_BLOCK"></a> [CIDR\_BLOCK](#input\_CIDR\_BLOCK) | CIDR block used for the netowkr (e.g. '24' for /24) | `string` | n/a | yes |
| <a name="input_CORES"></a> [CORES](#input\_CORES) | Number of cores for the LXC container | `number` | `1` | no |
| <a name="input_GATEWAY"></a> [GATEWAY](#input\_GATEWAY) | Default gateway of the network | `string` | n/a | yes |
| <a name="input_INTERFACE_NAME"></a> [INTERFACE\_NAME](#input\_INTERFACE\_NAME) | Default interface name of instance | `string` | `"eth0"` | no |
| <a name="input_LOCAL_DOMAIN"></a> [LOCAL\_DOMAIN](#input\_LOCAL\_DOMAIN) | Local domain of the network | `string` | n/a | yes |
| <a name="input_LXC_PASSWORD"></a> [LXC\_PASSWORD](#input\_LXC\_PASSWORD) | Default password for the LXC | `string` | n/a | yes |
| <a name="input_LXC_TEMPLATE"></a> [LXC\_TEMPLATE](#input\_LXC\_TEMPLATE) | Location of the LXC template to use for the container | `string` | n/a | yes |
| <a name="input_MASTER_IP"></a> [MASTER\_IP](#input\_MASTER\_IP) | IP address of the first LXC container | `string` | n/a | yes |
| <a name="input_MEMORY"></a> [MEMORY](#input\_MEMORY) | Memory of the LXC container | `number` | `256` | no |
| <a name="input_NAMESERVER"></a> [NAMESERVER](#input\_NAMESERVER) | Nameserver IP address | `string` | n/a | yes |
| <a name="input_PIHOLE_API_KEY"></a> [PIHOLE\_API\_KEY](#input\_PIHOLE\_API\_KEY) | Pihole API to create DNS entries | `string` | n/a | yes |
| <a name="input_PM_BACKUP_NODE"></a> [PM\_BACKUP\_NODE](#input\_PM\_BACKUP\_NODE) | Proxmox node that will host the BACKUP LXC (e.g. pve2) | `string` | n/a | yes |
| <a name="input_PM_MASTER_NODE"></a> [PM\_MASTER\_NODE](#input\_PM\_MASTER\_NODE) | Proxmox node that will host the MASTER LXC (e.g. pve1) | `string` | n/a | yes |
| <a name="input_STORAGE_NAME"></a> [STORAGE\_NAME](#input\_STORAGE\_NAME) | Storage of the disk space for LXC | `string` | `"local-lvm"` | no |
| <a name="input_STORAGE_SIZE"></a> [STORAGE\_SIZE](#input\_STORAGE\_SIZE) | Storage size of the disk for LXC | `string` | `"8G"` | no |
| <a name="input_VIRTUAL_IP"></a> [VIRTUAL\_IP](#input\_VIRTUAL\_IP) | Virtual IP to assign to Proxmox keepalived | `string` | n/a | yes |

## Outputs

No outputs.
