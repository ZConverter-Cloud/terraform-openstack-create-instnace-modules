resource "openstack_blockstorage_volume_v3" "boot_volume" {
  name     = "${var.vm_name}-boot-volume"
  size     = var.OS_boot_size
  image_id = data.openstack_images_image_ids_v2.get_image.ids[0]
}

resource "openstack_blockstorage_volume_v3" "add_volume" {
  count  = length(var.volume)
  region = var.region
  name   = "${var.vm_name}-add-volume-${count.index}"
  size   = var.volume[count.index]
}

resource "openstack_compute_volume_attach_v2" "volume_attach" {
  count       = length(var.volume)
  instance_id = openstack_compute_instance_v2.kakao_create_instance.id
  volume_id   = openstack_blockstorage_volume_v3.add_volume[count.index].id
}