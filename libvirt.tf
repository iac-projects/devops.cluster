provider "libvirt" {
  uri = "qemu:///system"
}

# create pool
resource "libvirt_pool" "ubuntu" {
   name = "ubuntu-pool"
   type = "dir"
   path = "/libvirt_images/ubuntu-pool/"
}

# create image
resource "libvirt_volume" "image-qcow2" {
  name = "ubuntu-amd64.qcow2"
  pool = libvirt_pool.ubuntu.name
  source = "${path.module}/downloads/bionic-server-cloudimg-amd64.img"
  format = "qcow2"
}


# add cloudinit disk to pool
resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit.iso"
  pool = libvirt_pool.ubuntu.name
  user_data = data.template_file.user_data.rendered
}

# read the configuration
data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}


# Define KVM domain to create
resource "libvirt_domain" "master" {
 
  #name should be unique!
  name = "master"
  memory = "8196"
  vcpu = 2
  
  #add the cloud init disk to share user data
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  #set to default libvirt network
  network_interface {
    wait_for_lease = true
    bridge = "br0"
    #hostname = "guest"
    #mac = "00:16:3e:25:1e:72"
  }

  boot_device {
    dev = [ "hd", "network"]
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  disk {
    volume_id = libvirt_volume.image-qcow2.id
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

}
