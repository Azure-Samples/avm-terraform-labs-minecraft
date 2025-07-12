locals {
  firewall_ip  = cidrhost(local.subnet_address_prefixes.firewall, 4)
}

module "virtual_network" {
  source        = "Azure/avm-res-network-virtualnetwork/azurerm"
  version       = "0.9.2"
  location      = local.location
  address_space = [var.virtual_network_address_space]
  name          = "vnet-minecraft"
  dns_servers = {
    dns_servers = [local.firewall_ip]
  }
  resource_group_name = module.resource_group.name
  subnets = {
    firewall = {
      name             = "AzureFirewallSubnet"
      address_prefixes = [local.subnet_address_prefixes.firewall]
      name             = "AzureFirewallSubnet"
    }
    app = {
      name                            = "app"
      address_prefixes                = [local.subnet_address_prefixes.app]
      default_outbound_access_enabled = false
      route_table = {
        id = module.route_table.resource_id
      }
      delegation = [
        {
          name = "Microsoft.App/environments"
          service_delegation = {
            name = "Microsoft.App/environments"
          }
        }
      ]
    }
    private_endpoint = {
      name                                          = "private-endpoint"
      address_prefixes                              = [local.subnet_address_prefixes.private_endpoint]
      default_outbound_access_enabled               = false
      private_link_service_network_policies_enabled = true
      route_table = {
        id = module.route_table.resource_id
      }
    }
  }
}

module "route_table" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.4.1"
  name                = "rt-tofirewall"
  resource_group_name = module.resource_group.name
  location            = local.location

  routes = {
    to-firewall = {
      name                   = "to-firewall"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = local.firewall_ip
    },
  }
}
