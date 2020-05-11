resource "libvirt_volume" "node" {
  count = var.node_count
  name = "node${count.index}"
  pool = libvirt_pool.k8s-pool.name
  base_volume_id = libvirt_volume.base.id
  format = "qcow2"
  size = var.node_disk_size
}

resource "libvirt_cloudinit_disk" "nodeinit" {
  count = var.node_count
  name = "nodeinit${count.index}"
  pool = libvirt_pool.k8s-pool.name
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "node" {
  count = var.node_count
  name = "node${count.index}"
  memory = var.node_memory
  vcpu  = var.node_cpus
  autostart = "true"

  network_interface {
      wait_for_lease = true
      hostname = "node${count.index}"
      bridge = var.bridge
      addresses      = ["192.168.1.${count.index + var.master_count + 100}"]
      mac            = "AA:BB:CC:11:22:5${count.index}"
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
