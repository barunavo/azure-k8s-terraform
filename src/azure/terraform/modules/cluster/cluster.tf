

resource "azurerm_kubernetes_cluster" "aks-getting-started" {
  name                  = var.cluster_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = var.dns_prefix            
  kubernetes_version    = var.kubernetes_version
  
  
  default_node_pool {
    name                  = "default"
    node_count            = var.node_count
    vm_size               = "Standard_E4s_v3"
    type                  = "VirtualMachineScaleSets"
    os_disk_size_gb       = var.os_disk_size_gb
    enable_node_public_ip = true
    availability_zones    = ["1", "2", "3"]
    enable_auto_scaling   = true
    min_count             = 1
    max_count             = 2
    vnet_subnet_id        = var.vnet_subnet_id
  }

  service_principal  {
    client_id = var.serviceprinciple_id
    client_secret = var.serviceprinciple_key
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
        key_data = var.ssh_key
    }
  }

  # network_profile {
  #     network_plugin = "kubenet"
  #     load_balancer_sku = "Standard"
  # }
  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    network_policy     = "calico"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = true
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }

}



