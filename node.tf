resource "libvirt_volume" "node" {
  count = var.node_count
  name = "node${count.index+1}"
  pool = libvirt_pool.base-pool.name
  base_volume_id = libvirt_volume.base.id
  format = "qcow2"
  size = var.node_disk_size
}

resource "libvirt_cloudinit_disk" "nodeinit" {
  count = var.node_count
  name = "nodeinit${count.index+1}"
  pool = libvirt_pool.base-pool.name
  user_data = data.template_file.node_data[count.index].rendered
  network_config = data.template_file.node_network[count.index].rendered
}

resource "libvirt_domain" "node" {
  count = var.node_count
  name = "node${count.index+1}"
  memory = var.node_memory
  vcpu  = var.node_cpus
  autostart = "true"

  network_interface {
    wait_for_lease = true
    bridge = var.bridge
    mac = "AA:BB:CC:11:22:0${count.index+1}"
  }

  boot_device {
    dev = ["hd", "network"]
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  disk {
      volume_id = element(libvirt_volume.node.*.id, count.index)
  }

  cloudinit = element(libvirt_cloudinit_disk.nodeinit.*.id, count.index)

  graphics {
    type = "vnc"
    listen_type = "address"
    autoport = true
  }

}

output "node_hostname" {
  value = "${libvirt_domain.node.*.network_interface.0.hostname}"
  description = "The hostname of the node server instance"
}

output "node_ip" {
  value = "${libvirt_domain.node.*.network_interface.0.addresses}"
  description = "The IP address of the node server instance"
}

