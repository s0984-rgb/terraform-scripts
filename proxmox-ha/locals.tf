locals {
  common_tags = "haproxy"
  master_tag  = "master"
  backup_tag  = "backup"
  master_tags = "${local.common_tags},${local.master_tag}"
  backup_tags = "${local.common_tags},${local.backup_tag}"
}