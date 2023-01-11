resource "azurerm_public_ip" "publicip" {
    name                       = var.vm_name
    location                   = var.location
    resource_group_name        = var.rg_name
    allocation_method          = "Static"

    tags = var.tags
}

resource "azurerm_network_interface" "nic" {
    name                      = "nic-${var.vm_name}"
    location                  = var.location
    resource_group_name       = var.rg_name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip.id
    }

    tags = var.tags
}


resource "azurerm_linux_virtual_machine" "ubuntu-vm" {
    name                            = var.vm_name
    location                        = var.location
    resource_group_name             = var.rg_name
    network_interface_ids           = [azurerm_network_interface.nic.id]
    size                            = var.vm_size
    admin_username                  = var.admin_username
    computer_name                   = var.vm_name
    disable_password_authentication = true

    admin_ssh_key {
      username      = var.admin_username
      public_key    = var.pubkey
    }

    os_disk {
        name                 = "osdisk-${var.vm_name}"
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference  {
        sku       = var.vm_sku.sku
        publisher = var.vm_sku.publisher
        offer     = var.vm_sku.offer
        version   = var.vm_sku.version
    }


    tags = var.tags
}

