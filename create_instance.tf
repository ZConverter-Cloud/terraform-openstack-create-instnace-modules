resource "tls_private_key" "key" {
  count     = var.create_key_pair_name != null && var.ssh_public_key == null && var.ssh_public_key_file == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "openstack_compute_keypair_v2" "create_key_pair" {
  count      = var.create_key_pair_name != null ? 1 : 0
  name       = var.create_key_pair_name
  public_key = tls_private_key.key[0].public_key_openssh
}

resource "openstack_compute_instance_v2" "openstack_create_instance" {
  name              = var.vm_name
  region            = var.region
  image_id          = data.openstack_images_image_ids_v2.get_image.ids[0]
  flavor_name       = var.flavor_name
  key_pair          = var.create_key_pair_name != null ? openstack_compute_keypair_v2.create_key_pair[0].name : var.key_pair_name
  availability_zone = data.openstack_compute_availability_zones_v2.zones.names[0]
  network {
    uuid = data.openstack_networking_network_v2.network.id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.boot_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  security_groups = formatlist(var.create_security_group_name != null ? var.create_security_group_name : var.security_group_name)

  user_data = var.user_data_file_path != null ? fileexists(var.user_data_file_path) != false ? base64encode(file(var.user_data_file_path)) : null : var.user_data != null ? base64encode(var.user_data) : null
}
