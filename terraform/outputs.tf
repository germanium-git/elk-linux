
output "elk01_public_ip" {
  value = module.elk-01.ubuntu_vm_public_ip
}


output "prometheus01_public_ip" {
  value = module.prm-01.ubuntu_vm_public_ip
}
