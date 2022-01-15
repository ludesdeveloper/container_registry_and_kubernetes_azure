provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = "azurepipeline"
  location = "East US"
}

module "acr" {
  source                  = "./modules/acr"
  acr_name                = "azurepipeline"
  acr_resource_group_name = module.resource_group.name
  acr_location            = module.resource_group.location
}

module "aks" {
  source       = "./modules/aks"
  aks_name     = "azurepipeline"
  aks_dns      = "azurepipeline"
  aks_location = module.resource_group.location
  aks_rg_name  = module.resource_group.name
}

output "client_certificate" {
  value = module.aks.client_certificate
}

output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}
