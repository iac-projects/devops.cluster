resource "libvirt_volume" "master" {
  count = var.master_count
  name = "master${count.index}"
  pool = libvirt_pool.base-pool.name
  base_volume_id = libvirt_volume.base.id
  format = "qcow2"
  size = var.master_disk_size
}

resource "libvirt_cloudinit_disk" "masterinit" {
  count = var.master_count
  name = "masterinit${count.index}"
  pool = libvirt_pool.base-pool.name
  user_data = data.template_file.master_data[count.index].rendered
  network_config = data.template_file.master_network[count.index].rendered
}

resource "libvirt_domain" "master" {
  count = var.master_count
  name = "master${count.index}"
  memory = var.master_memory
  vcpu  = var.master_cpus
  autostart = "true"

  network_interface {
    wait_for_lease = true
    bridge = var.bridge
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
      volume_id = element(libvirt_volume.master.*.id, count.index)
  }

  cloudinit = element(libvirt_cloudinit_disk.masterinit.*.id, count.index)

  graphics {
    type = "vnc"
    listen_type = "address"
    autoport = true
  }

}

output "master_hostname" {
  value = "${libvirt_domain.master.*.network_interface.0.hostname}"
  description = "The hostname of the master server instance"
}

output "master_ip" {
  value = "${libvirt_domain.master.*.network_interface.0.addresses}"
  description = "The IP address of the master server instance"
}

