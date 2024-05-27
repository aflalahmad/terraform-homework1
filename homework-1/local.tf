locals {
  rules_csv = csvdecode(file(var.rules_file))
    nsg_names = [for i in range(var.nsg_count) : "nsg-subnet${i + 1}"]
      vnet_ids = {
    for vnet_key, vnet_val in azurerm_virtual_network.vnets:
    vnet_key => [for subnet in vnet_val.subnet : subnet.id]
  
  }
}


