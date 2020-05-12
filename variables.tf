data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.cfg")}"
  #count = var.master_count
  vars = {
    hostname = "k8s"
    #hostname = "master${count.index}"
    #username           = var.username
    #ssh_public_key     = file(var.ssh_public_key)
    #packages           = jsonencode(var.packages)
  }
}

variable nameservers {
  type    = list
  default = ["192.168.1.100","192.168.1.101"]
}

variable "ssh_public_key" {
  description = "Path to SSH Public Key file from ssh-keygen"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "bridge" {
  description = "Name of the libvirt netowkr interface to use"
  type        = string
  default     = "br0"
}

variable "master_count" {
  description = "Number of masters"
  type        = string
  default     = "1"
}

variable "master_cpus" {
  description = "Number of CPUs to assign to the masters"
  type        = string
  default     = "2"
}

variable "master_memory" {
  description = "Amount of memory in MiB to assign to the masters"
  type        = string
  default     = "4096"
}

variable "master_disk_size" {
  description = "Size of the master disk in bytes"
  type        = string
  default     = "10000000000"
}

variable "node_count" {
  description = "Number of nodes"
  type        = string
  default     = "1"
}

variable "node_cpus" {
  description = "Number of CPUs to assign to the nodes"
  type        = string
  default     = "2"
}

variable "node_memory" {
  description = "Amount of memory in MiB to assign to the nodes"
  type        = string
  default     = "8196"
}

variable "node_disk_size" {
  description = "Size of the node disk in bytes"
  type        = string
  default     = "30000000000"
}
