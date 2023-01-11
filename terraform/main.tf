module "myrg" {
    source                  = "./modules/res_group"
    location                = var.location
    rg_name                 = var.rg_name
    tags                    = var.tags
}

module "vnet" {
    source                  = "./modules/vnet"
    location                = var.location
    rg_name                 = module.myrg.rg_name
    tags                    = var.tags
    vnet_name               = var.vnet_name
    vnet_address_space      = var.vnet_address_space
}

module "nsg" {
    source                  = "./modules/nsg"
    nsg_name                = var.nsg_name
    nsg_rules               = var.nsg_rules
    location                = var.location
    rg_name                 = module.myrg.rg_name
    tags                    = var.tags
}


module "subnet01" {
    source                  = "./modules/subnet"
    location                = var.location
    rg_name                 = var.rg_name
    nsg_id                  = module.nsg.nsg_id
    subnet_name             = "subnet01"
    subnet_cidr             = cidrsubnet(var.vnet_address_space, 8, 1)
    vnet_name               = module.vnet.vnet_name
}


module "elk-01" {
    source                  = "./modules/ubuntu_vm"
    location                = var.location
    vm_name                 = "elk-01"
    rg_name                 = var.rg_name
    subnet_id               = module.subnet01.subnet-id
    pubkey                  = file("./key/id_rsa.pub")
    keypath                 = var.keypath
    admin_username          = var.admin_username
    vm_size                 = "Standard_D8s_v3"
    tags                    = var.tags
    vm_sku                  = var.elk_vm_sku
}


module "prm-01" {
    source                  = "./modules/ubuntu_vm"
    location                = var.location
    vm_name                 = "prm-01"
    rg_name                 = var.rg_name
    subnet_id               = module.subnet01.subnet-id
    pubkey                  = file("./key/id_rsa.pub")
    keypath                 = var.keypath
    admin_username          = var.admin_username
    vm_size                 = "Standard_D2s_v3"
    tags                    = var.tags
    vm_sku                  = var.elk_vm_sku
}
