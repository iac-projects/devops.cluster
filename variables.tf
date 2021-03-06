#Nodes machines settings

variable "node_count" {
  description = "Number of nodes"
  type        = string
  default     = "5"
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
  default     = "34359738368" #32Gb
}

variable "data_disk_size" {
  description = "Size of the data disk in bytes"
  type        = string
  default     = "68719476736" #64Gb
}


#Account and security settings

variable "password" {
  description = "OS root password"
  type        = string
  default     = "hardpassword"
}

variable "ssh_public_key" {
  description = "Path to SSH Public Key file created by ssh-keygen"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}


#Network settings

variable "bridge" {
  description = "Name of the libvirt network interface to use"
  type        = string
  default     = "br0"
}

variable "dhcp" {
  description = "Boolean flag for enabling to retrieve IP-address from DHCP-server. If false - it should be set ip_address, gateway, nameservers"
  type        = string
  default     = "true"
}

variable "node_ip_address" {
  description = "IP address template for node machines"
  type        = string
  default     = "192.168.1.100/24"
}

variable "gateway" {
  description = "IP address of gateway"
  type        = string
  default     = "192.168.1.1"
}

variable nameservers {
  description = "IP addresses list of dns servers"
  type    = list
  default = ["192.168.1.1","8.8.8.8"]
}

#Packages
variable packages {
  description = "packages"
  type    = list
  default = ["qemu-guest-agent"]
}







