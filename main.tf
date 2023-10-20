## Read Existing subnets
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

## Read Resource Group

data "azurerm_resource_group" "resource_group_base" {
  name = var.resource_group_name
}

## Read pull_secret, service principal ID and Secret from Azure Key Vault
data "azurerm_key_vault" "key_vault" {
  name                = var.akv_name
  resource_group_name = var.akv_resource_group
}

data "azurerm_key_vault_secret" "pull_secret" {
  name         = var.pull_secret_name
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

## ARO Cluster Deploy

resource "azureopenshift_redhatopenshift_cluster" "cluster" {
  name                   = var.cluster_name
  location               = var.location
  resource_group_name    = var.main.name
  cluster_resource_group = var.resource_group_managed
  tags                   = var.tags

  master_profile {
    subnet_id = data.azurerm_subnet.control_subnet.id
    vm_size   = var.master_vm_size
  }

  worker_profile {
    subnet_id    = data.azurerm_subnet.worker_subnet.id
    node_count   = var.worker_node_count
    vm_size      = var.worker_vm_size
    disk_size_gb = var.worker_vm_disk_size
  }

  service_principal {
    client_id     = data.azurerm_key_vault_secret.sp_client_id.value
    client_secret = data.azurerm_key_vault_secret.sp_client_secret.value
  }

  api_server_profile {
    visibility = var.api_server_profile
  }

  ingress_profile {
    visibility = var.ingress_profile
  }

  cluster_profile {
    pull_secret            = data.azurerm_key_vault_secret.pull_secret.value
    version                = var.aro_version
    domain                 = var.domain_name
    fips_validated_modules = var.fips
    resource_group_id      = var.resource_group_base.id
  }

  network_profile {
    outbound_type = var.outbound_type
    pod_cidr      = var.pod_cidr
    service_cidr  = var.service_cidr
  }
}
