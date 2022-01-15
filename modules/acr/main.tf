resource "azurerm_container_registry" "container_registry" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
  location            = var.acr_location
  sku                 = "Premium"
  admin_enabled       = false
  #georeplications {
  #  location                = "East US"
  #  zone_redundancy_enabled = true
  #  tags                    = {}
  #}
  #georeplications {
  #  location                = "westeurope"
  #  zone_redundancy_enabled = true
  #  tags                    = {}
  #}
}
