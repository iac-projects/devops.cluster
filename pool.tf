# create pool
resource "libvirt_pool" "k8s-pool" {
   name = "k8s-pool"
   type = "dir"
   path = "/libvirt_images/k8s-pool/"
}

