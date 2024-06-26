<!-- BEGIN_TF_DOCS -->
# Terraform Azure Infrastructure

This Terraform project sets up Azure infrastructure including virtual networks (VNets) with subnets and network security groups (NSGs). The configuration is designed to be dynamic, allowing for scalable and customizable deployments.

## Architecture Diagram
![architecture](https://github.com/aflalahmad/terraform-homework1/assets/105841418/2b38d9bb-67aa-4b3c-bfd8-7f1c26b77944)

```hcl

data "azurerm_resource_group" "rg" {
  name = "data-block-rg"
}

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = each.key
  address_space       = [each.value.address_space]
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  dynamic "subnet" {
  for_each = each.value.Subnets

  content {
       name           = subnet.value.name
      address_prefix = cidrsubnet(each.value.address_space, subnet.value.newbits, subnet.value.netnum)
    }
  }
  
 depends_on = [data.azurerm_resource_group.rg]
  
  
}


resource "azurerm_network_security_group" "nsg" {
  for_each = toset(local.nsg_names)

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  dynamic "security_rule" {
    for_each = { for rule in local.rules_csv : rule.name => rule }
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  for_each = { for idx, subnet_id in flatten([for vnet in local.vnet_ids : vnet]) : idx => subnet_id }

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg[local.nsg_names[each.key]].id

  depends_on = [azurerm_network_security_group.nsg]
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0.2)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.0.2)

## Resources

The following resources are used by this module:

- [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_subnet_network_security_group_association.nsg-association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_virtual_network.vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_vnets"></a> [vnets](#input\_vnets)

Description: The virtual network value must not be empty

Type:

```hcl
map(object({
      address_space = string
      Subnets = list(object({
        name = string
        newbits = number
        netnum = number
      }))
      
  }))
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_nsg_count"></a> [nsg\_count](#input\_nsg\_count)

Description: The count value must be in number

Type: `string`

Default: `4`

### <a name="input_rules_file"></a> [rules\_file](#input\_rules\_file)

Description: The rules files must be saved in .csv file name.

Type: `string`

Default: `"rules-20.csv"`

## Outputs

The following outputs are exported:

### <a name="output_associate"></a> [associate](#output\_associate)

Description: The name or ID of the associate resource.

### <a name="output_nsg"></a> [nsg](#output\_nsg)

Description: The name or ID of the network security group(NSG) .

### <a name="output_rg"></a> [rg](#output\_rg)

Description: The name of the Resource Group (RG).

### <a name="output_vnet"></a> [vnet](#output\_vnet)

Description: The name of the Virtual Network (VNet).

## Modules

No modules.

## Contributing

We welcome contributions to improve this Terraform module.
<!-- END_TF_DOCS -->