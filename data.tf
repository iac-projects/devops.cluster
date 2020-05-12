data "template_file" "master_data" {
  template = "${file("${path.module}/templates/master.yml")}"
  count = var.master_count
  vars = {
    hostname = "master${count.index}"
    ssh_public_key = file(var.ssh_public_key)
    nameservers = jsonencode(var.nameservers)
    #username           = var.username
    #packages           = jsonencode(var.packages)
  }
}

data "template_file" "master_network" {
  template = "${file("${path.module}/templates/master_network.yml")}"
  count = var.master_count
}
