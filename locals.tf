locals {
  minecraft_port = 25565

  # The module will randomly select a location from the list below
  locations = [
    "swedencentral",
    "uksouth",
    "francecentral",
    "japaneast",
    "canadacentral",
    "centralus",
    "northeurope",
    "eastus",
  ]

  region_index = var.lab_instance_id % length(local.locations)
  location = local.locations[region_index]
}

module "subnet_address_prefixes" {
  source  = "Azure/avm-utl-network-ip-addresses/azurerm"
  version = "0.1.0"
  address_space = var.virtual_network_address_space
  address_prefixes = {
    firewall = 24
    app      = 23
    private_endpoint = 24
  }
}

locals {
  subnet_address_prefixes = module.subnet_address_prefixes.address_prefixes
}
