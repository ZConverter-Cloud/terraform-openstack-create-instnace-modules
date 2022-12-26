data "openstack_compute_availability_zones_v2" "zones" {}

data "openstack_images_image_ids_v2" "get_image" {
  name_regex = var.OS_name
  sort       = "updated_at"
}

data "openstack_networking_network_v2" "network" {
  name = var.private_network_name
}

data "openstack_networking_secgroup_v2" "get_security_group_id" {
  count = var.security_group_name != null ? 1 : 0
  name = local.security_groups[0]
}