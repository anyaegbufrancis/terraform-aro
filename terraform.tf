terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.43"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.75.0"
    }
    azureopenshift = {
      source  = "rh-mobb/azureopenshift"
      version = "0.2.0-pre"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.0.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id = "put-tenant-id-here"
  environment = "usgovernment"
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {
  subscription_id = var.subscription_id
  tenant_id = "put-tenant-id-here"
  environment = "usgovernment"
  skip_provider_registration = true
}

provider "azureopenshift" {
  subscription_id = var.subscription_id
}

# data "azurerm_client_config" "current" {}

# output "testing" {
#   value = data.azurerm_client_config.current
# }
