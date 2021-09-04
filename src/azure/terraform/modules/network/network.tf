resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.azurerm_resource_group 
  location            = var.location 
  address_space       = var.address_space
} 

resource "azurerm_subnet" "aks_subnet" {
  count                = length(var.cidr)
  name                 = "aks_subnet-0${count.index + 1}"
  resource_group_name  = var.azurerm_resource_group 
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefix       = element(tolist(var.cidr), count.index) 
  service_endpoints    = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
}

output "subnet_id_1" {
  value = azurerm_subnet.aks_subnet[0].id
}

output "subnet_id_2" {
  value = azurerm_subnet.aks_subnet[1].id
}
