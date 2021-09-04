resource "azurerm_storage_account" "example" {
  name                     = var.storageaccountname
  resource_group_name      = var.resource_group_name

  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  network_rules {
    default_action             = "Allow"
    #ip_rules                   = ["0.0.0.0"]
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  tags = {
    environment = var.environment
  } 
}

variable "environment"{}
variable "storageaccountname"{}
variable "resource_group_name"{}
variable "location"{}
variable "virtual_network_subnet_ids" {}
