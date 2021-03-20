locals {
  vpn_links_by_name = zipmap(module.vpn.subnets_names, module.vpn.subnets_self_links)
}