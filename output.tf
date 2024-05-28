output "rg" {
  value = azurerm_resource_group.rg.name
  description = "The name of the Resource Group (RG)."
}
output "vnet" {
  value = azurerm_virtual_network.vnets
  description = "The name of the Virtual Network (VNet)."
}
output "nsg" {
  value = azurerm_network_security_group.nsg
  description = "The name or ID of the network security group(NSG) ."
}
output "associate" {
  value = azurerm_subnet_network_security_group_association.nsg-association
  description = "The name or ID of the associate resource."
}