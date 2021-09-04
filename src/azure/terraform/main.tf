provider "azurerm" {
  #version = "=2.5.0"

   #subscription_id = var.subscription_id
   #client_id       = var.serviceprinciple_id
   #client_secret   = var.serviceprinciple_key
   #tenant_id       = var.tenant_id

  features {}
}

resource "azurerm_resource_group" "aks-getting-started" {
  name                    = "aks-getting-started${terraform.workspace}"
  location                = "eastus" 
}

module "vnet" {
  source                  = "./modules/network"
  address_space           = ["10.0.0.0/8"]
  cidr                    = ["10.10.0.0/24", "10.10.1.0/24"]
  aks_vnet_name           = "pocnet${terraform.workspace}"
  azurerm_resource_group  = azurerm_resource_group.aks-getting-started.name
  location                = azurerm_resource_group.aks-getting-started.location
  depends_on = [
    azurerm_resource_group.aks-getting-started
  ]
}


module "acr" {
  source                  = "./modules/registry"
  acr_name                = "registry${terraform.workspace}"
  resource_group_name     = azurerm_resource_group.aks-getting-started.name
  location                = azurerm_resource_group.aks-getting-started.location
  depends_on              = [
    azurerm_resource_group.aks-getting-started
  ]
}


module "cluster" {
  source                = "./modules/cluster/"
  cluster_name          = "cluster${terraform.workspace}"
  dns_prefix            = "cluster${terraform.workspace}"
  os_disk_size_gb       = 100
  node_count            = 1 
  serviceprinciple_id   = var.serviceprinciple_id
  serviceprinciple_key  = var.serviceprinciple_key
  resource_group_name   = azurerm_resource_group.aks-getting-started.name
  location              = azurerm_resource_group.aks-getting-started.location
  ssh_key               = var.ssh_key
  kubernetes_version    = var.kubernetes_version
  vnet_subnet_id        = module.vnet.subnet_id_1
  depends_on = [
    azurerm_resource_group.aks-getting-started
  ]
}

module "storageaccount" {
  source                = "./modules/storage-account"
  environment           = "${terraform.workspace}"
  storageaccountname    = "barunavo${terraform.workspace}"
  resource_group_name   = azurerm_resource_group.aks-getting-started.name
  location              = azurerm_resource_group.aks-getting-started.location
  virtual_network_subnet_ids = [module.vnet.subnet_id_2, module.vnet.subnet_id_2]
}


/*
module "gpunodepool" {
  source                = "./modules/nodepool"
  vm_size               = "Standard_NC6"
  os_disk_size_gb       = 100
  node_count            = 1  
  kubernetes_cluster_id = module.cluster.kubernetes_cluster_id
  name                  = "gpu${terraform.workspace}"
  os_type               = "Linux"
  depends_on = [
    module.cluster
  ]
}
*/

/*
module "k8s" {
  source                = "./modules/k8s/"
  host                  = "${module.cluster.host}"
  client_certificate    = "${base64decode(module.cluster.client_certificate)}"
  client_key            = "${base64decode(module.cluster.client_key)}"
  cluster_ca_certificate= "${base64decode(module.cluster.cluster_ca_certificate)}"
}
*/
/*
provider "helm" {
  kubernetes {
    host                   = "${module.cluster.host}"
    cluster_ca_certificate = "${base64decode(module.cluster.cluster_ca_certificate)}"
  }
}
*/


