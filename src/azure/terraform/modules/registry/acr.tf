resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = var.resource_group_name #azurerm_resource_group.aks_demo_rg.name
  location                 = var.location
  sku                      = "Basic"
  admin_enabled            = false
}

variable "acr_name" {
    default = ""
}

variable "location" {
    default = ""
}

variable "resource_group_name" {
    default = ""
}