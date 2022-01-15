resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}
resource "azurerm_log_analytics_workspace" "test" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "ContainerInsights-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.aks_location
  resource_group_name = var.aks_rg_name
  sku                 = "PerGB2018"
}
resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = var.aks_location
  resource_group_name   = var.aks_rg_name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id
  workspace_name        = azurerm_log_analytics_workspace.test.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = var.aks_name
  location            = var.aks_location
  resource_group_name = var.aks_rg_name
  dns_prefix          = var.aks_dns

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
    }
  }
  tags = {
    Environment = "Production"
  }
}
