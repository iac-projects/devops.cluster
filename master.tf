resource "libvirt_volume" "master" {
  count = var.master_count
  name = "master${count.index}"
  pool = libvirt_pool.k8s-pool.name
  base_volume_id = libvirt_volume.base.id
  format = "qcow2"
  size = var.master_disk_size
}

resource "libvirt_cloudinit_disk" "masterinit" {
  count = var.master_count
  name = "masterinit${count.index}"
  pool = libvirt_pool.k8s-pool.name
  user_data = data.template_file.master_data[count.index].rendered
  network_config = data.template_file.master_network[count.index].rendered
}

resource "libvirt_domain" "master" {
  count = var.master_count
  name = "master${count.index}"
  memory = var.master_memory
  vcpu  = var.master_cpus
  autostart = "true"

  #network_interface {
      #network_id = libvirt_network.k8s_network.id
      #wait_for_lease = true
      #hostname = "master${count.index}"
      #network_name = "default"
      #network_id = libvirt_network.default.id
      #bridge = var.bridge
      #addresses = ["192.168.1.${count.index + 100}"]
      #mac = "AA:BB:CC:11:22:0${count.index}"
  #}
  
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


  #provisioner "remote-exec" {
  #  inline = ["sudo hostnamectl set-hostname master${count.index}"]
  #}

  #provisioner "local-exec" {
  # command = "sudo hostnamectl set-hostname master${count.index}"
  #}

}

output "master_hostname" {
  value = "${libvirt_domain.master.*.network_interface.0.hostname}"
  description = "The hostname of the master server instance"
}

output "master_ip" {
  value = "${libvirt_domain.master.*.network_interface.0.addresses}"
  description = "The IP address of the master server instance"
}

