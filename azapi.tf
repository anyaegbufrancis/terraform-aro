## Reads details of existing worker and control subnets. 
## This section is for existing subnets
data "azurerm_subnet" "control_subnet" {
  name                 = var.azr_control_subnet
  virtual_network_name = var.azr_vnet
  resource_group_name  = var.azr_resource_group_vnet
}

data "azurerm_subnet" "worker_subnet" {
  name                 = var.azr_worker_subnet
  virtual_network_name = var.azr_vnet
  resource_group_name  = var.azr_resource_group_vnet
}

## Read details of existing resource group named in variable resource_group_name

data "azurerm_resource_group" "resource_group_base" {
  name = var.resource_group_name
}

## Read pull_secret, service principal ID and Secret from existingAzure Key Vault
## User account logged in using 'az login' must have read access to Azure Key Vault
## pull secret and service principal details required to create the aro cluster.
data "azurerm_key_vault" "key_vault" {
  name                = var.akv_name
  resource_group_name = var.akv_resource_group
}

data "azurerm_key_vault_secret" "pull_secret" {
  name         = local.pull_secret
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "sp_client_id" {
  name         = local.sp_client_id
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "sp_client_secret" {
  name         = local.sp_client_secret
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

## This module creates the aro cluster. 
## https://github.com/rh-mobb/terraform-provider-azureopenshift/blob/main/azureopenshift/redhatopenshift_cluster_resource.go
## and https://github.com/rh-mobb/terraform-provider-azureopenshift/blob/main/docs/resources/redhatopenshift_cluster.md
## For relevant options

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azapi_resource" "aro_cluster" {
  name      = var.cluster_name
  location  = var.location
  parent_id = data.azurerm_resource_group.resource_group.id
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2023-04-01"
  tags      = var.tags

  body = jsonencode({
    properties = {
      clusterProfile = {
        domain               = var.domain_name
        fipsValidatedModules = var.fips
        resourceGroupId      = data.azurerm_resource_group.resource_group_base.id
        pullSecret           = data.azurerm_key_vault_secret.pull_secret.value
        version              = var.aro_version
      }
      networkProfile = {
        podCidr      = var.pod_cidr
        serviceCidr  = var.service_cidr
        outboundType = var.outbound_type
      }
      servicePrincipalProfile = {
        clientId     = data.azurerm_key_vault_secret.sp_client_id.value
        clientSecret = data.azurerm_key_vault_secret.sp_client_secret.value
      }
      masterProfile = {
        vmSize   = var.master_vm_size
        subnetId = data.azurerm_subnet.control_subnet.id
      }
      workerProfiles = [
        {
          vmSize   = var.worker_vm_size
          subnetId = data.azurerm_subnet.worker_subnet.id
          count    = var.worker_node_count
        }
      ]
      apiserverProfile = {
        visibility = var.api_server_profile
      }
      ingressProfiles = [
        {
          visibility = var.ingress_profile
        }
      ]
    }
  })

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

output "client_id" {
  value     = data.azurerm_key_vault_secret.sp_client_id
  sensitive = true
}
output "client_secret" {
  value     = data.azurerm_key_vault_secret.sp_client_secret
  sensitive = true
}
output "pull_secret" {
  value     = data.azurerm_key_vault_secret.pull_secret
  sensitive = true
}

output "test_data" {
  value = data.azurerm_subnet.worker_subnet.id
}
