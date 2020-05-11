resource "libvirt_volume" "base" {
  name = "base"
  pool = "k8s-pool"
  source = "${path.module}/downloads/bionic-server-cloudimg-amd64.img"
  format = "qcow2"
}
