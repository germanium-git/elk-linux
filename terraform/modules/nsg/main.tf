resource "azurerm_network_security_group" "nsg" {
    name                = var.nsg_name
    location            = var.location
    resource_group_name = var.rg_name

    tags = var.tags
}


resource "azurerm_network_security_rule" "sec_rule" {
    for_each                    = var.nsg_rules
    resource_group_name         = var.rg_name
    network_security_group_name = azurerm_network_security_group.nsg.name
    name                        = each.key
    priority                    = each.value[0]
    direction                   = each.value[1]
    access                      = each.value[2]
    protocol                    = each.value[3]
    source_port_range           = each.value[4]
    destination_port_range      = each.value[5]
    source_address_prefix       = each.value[6]
    destination_address_prefix  = each.value[7]
}