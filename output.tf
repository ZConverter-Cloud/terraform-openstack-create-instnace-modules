output "Summary" {
  value = {
    IP = openstack_compute_floatingip_v2.floatingip.address,
    VM_NAME = var.vm_name,
    OS = var.OS_name
  }
}
