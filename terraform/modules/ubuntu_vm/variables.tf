variable "location" {}
variable "vm_name" {}

variable "rg_name" {}
variable "subnet_id" {}

# The Public SSH Key which should be written to the path defined above.
variable "pubkey" {}

#The path of the destination file on the virtual machine
variable "keypath" {}

variable "vm_size" {}

variable "vm_sku" {}

variable "tags" {}

variable "admin_username" {}