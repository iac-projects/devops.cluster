data "template_file" "node_data" {
  template = "${file("${path.module}/templates/node.yml")}"
  count = var.node_count
  vars = {
    hostname = "node${count.index+1}"
    ssh_public_key = file(var.ssh_public_key)
    #username = var.username
    password = var.password
    packages = jsonencode(var.packages)
  }
}

data "template_file" "node_network" {
  template = "${file("${path.module}/templates/network_dhcp.yml")}"
  count = var.node_count
  vars = {
  }
}
