data "template_file" "master_data" {
  template = "${file("${path.module}/templates/master.yml")}"
  count = var.master_count
  vars = {
    hostname = "master${count.index}"
    ssh_public_key = file(var.ssh_public_key)
    nameservers = jsonencode(var.nameservers)
    username = var.username
    password = var.password
    packages = jsonencode(var.packages)
  }
}

data "template_file" "master_network" {
  template = "${file("${path.module}/templates/network.yml")}"
  count = var.master_count
  vars = {
    dhcp = var.dhcp
    ip_address = var.master_ip_address
    gateway = var.gateway
    nameservers = jsonencode(var.nameservers)
  }
}

