resource "azurerm_kubernetes_cluster_node_pool" "gpu_nodepool" {
  name                  = var.name
  kubernetes_cluster_id = var.kubernetes_cluster_id
  vm_size               = var.vm_size
  node_count            = var.node_count
  os_disk_size_gb       = var.os_disk_size_gb
  os_type               = var.os_type
}

variable "kubernetes_cluster_id"{}
variable "vm_size"{}
variable "node_count"{}
variable "os_disk_size_gb"{}

variable "name" {}
variable "os_type" {}
