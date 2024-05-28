output "rg" {
  value = azurerm_resource_group.rg.name
}
output "vnet" {
  value = azurerm_virtual_network.vnets
}
output "nsg" {
  value = azurerm_network_security_group.nsg
}
output "associate" {
  value = azurerm_subnet_network_security_group_association.nsg-association
}