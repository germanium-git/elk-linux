# --Define the location of the Azure VPN gateway
variable "location" {
  default = "West Europe"
}

variable "rg_name" {
  default = "rg-nemedpet-elk-tf"
}

variable "vnet_address_space" {
  default = "10.0.0.0/16"
}

variable "vnet_name" {
  default = "vnet-elk"
}


variable "nsg_name" {
  default = "nsg-elk"
}

# --Network Security Group rules protecting the VM(s)
variable "nsg_rules" {
  description = "Network Security Group"
  type = map(list(string))

  # The structure is as follows 
  # name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]
  default = {
    #allowall = ["100", "Inbound", "Allow", "*", "*", "*", "*", "*",]
    AllVNETIn    = ["100", "Inbound", "Allow", "*", "*", "*", "10.0.0.0/16", "*",]
    SSH          = ["110", "Inbound", "Allow", "Tcp", "*", "22", "*", "*",]
    Kibana       = ["120", "Inbound", "Allow", "Tcp", "*", "5601", "185.230.172.74/32", "*",]
    Syslog       = ["130", "Inbound", "Allow", "Udp", "*", "5000", "185.230.172.74/32", "*",]
    Prometheus   = ["140", "Inbound", "Allow", "Tcp", "*", "9090", "185.230.172.74/32", "*",]
    OutAll       = ["100", "Outbound", "Allow", "*", "*", "*", "*", "*",]
  }
}

# --The Account to access VM(s)
variable "admin_username" {
  default = "azureuser"
}

# The path of the destination file on the virtual machine where the key will be written.
variable "keypath" {
  default = "/home/azureuser/.ssh/authorized_keys"
}

variable "pubkey" {
  default = "./key/id_rsa.pub"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default = {
    environment = "demo"
    owner       = "nemedpet"
  }
}


variable "elk_vm_sku" {
  type        = map(string)
  description = "ELK VM SKU - storage_image_reference"
  default = {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

variable "prm_vm_sku" {
  type        = map(string)
  description = "Prometheus VM SKU - storage_image_reference"
  default = {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}