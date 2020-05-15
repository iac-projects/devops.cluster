resource "libvirt_volume" "base" {
  name = "base"
  pool = "base-pool"
  source = "${path.module}/downloads/bionic-server-cloudimg-amd64.img"
  format = "qcow2"
}
