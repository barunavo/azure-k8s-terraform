variable "serviceprinciple_id" {
}

variable "serviceprinciple_key" {
}

variable "location" {
  default = ""
}

variable "kubernetes_version" {
    default = ""
}

variable "ssh_key" {}

variable "cluster_name" {}

variable "dns_prefix"{}

variable "resource_group_name"{}
variable "os_disk_size_gb"{}
variable "node_count" {}
variable "vnet_subnet_id" {}