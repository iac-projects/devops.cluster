# create pool
resource "libvirt_pool" "base-pool" {
   name = "base-pool"
   type = "dir"
   path = "/libvirt_images/base-pool/"
}

