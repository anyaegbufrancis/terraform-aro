## This file contains ALL variables. To deploy any environment, customize this 
## file only
variable "cluster_name" {
  type        = string
  description = <<EOF
  *** AZR_CLUSTER_NAME ***
  The name of the cluster is embedded in the 
  FQDN uris of the cluster 
  (eg: https://console-openshift-console.apps.sandbox.usgovvirginia.aroapp.azure.us/)
  EOF
  default     = "sandbox"
}

variable "domain_name" {
  type        = string
  description = <<EOF
  *** AZR_CLUSTER_NAME ***
  ARO Domain name
  EOF
  default     = "sandbox"
}

variable "pod_cidr" {
  type        = string
  description = <<EOF
  *** AZR_POD_CIDR ***
  Cluster Pod CIDR
  EOF
  default     = "10.0.0.0/18"
}

variable "service_cidr" {
  type        = string
  description = <<EOF
  *** AZR_SERVICE_CIDR ***
  ARO Service CIDR
  EOF
  default     = "172.32.0.0/16"
}

variable "location" {
  type        = string
  description = <<EOF
  *** AZR_RESOURCE_LOCATION ***
  ARO Azure Location
  EOF
  default     = "usgovvirginia"
}

variable "region" {
  type        = string
  description = <<EOF
  *** AZR_REGION ***
  Cluster ARO Region
  EOF
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = <<EOF
  *** AZR_RESOURCE_GROUP_BASE ***
  A pre-existing AzureGov RG within AZR_SUBSCRIPTION where you want the ARO resource type to be installed
  - NOTE: the installer will create a single ARO resource in this RG. All cluster infrastructure will be created 
  in the AZR_RESOURCE_GROUP_MANAGED defined below
  EOF
  default     = "EKHO-GV-D-RGP-CUST-01"
}

variable "resource_group_managed" {
  type        = string
  description = <<EOF
  *** AZR_RESOURCE_GROUP_MANAGED ***
  A non-existent AzureGov RG within AZR_SUBSCRIPTION where the 
  new cluster infrastructure will be created.
  EOF
  default     = "EKHO-GV-D-RGP-CUST-02"
}

variable "resource_group_vnet" {
  type        = string
  description = <<EOF
  *** AZR_RESOURCE_GROUP_VNET ***
  A pre-existing AzureGov RG within AZR_SUBSCRIPTION containing the 
  VNET for cluster networking.
  EOF
  default     = "EKHO-GV-D-RGP-VNT-01"
}

variable "api_server_profile" {
  type        = string
  description = <<EOF
  Ingress Controller Profile Visibility - Public or Private
  Default "Public".
  EOF
  default     = "Private"
}

variable "ingress_profile" {
  type        = string
  description = <<EOF
  Ingress Controller Profile Visibility - Public or Private
  Default "Public".
  EOF
  default     = "Private"
}

variable "fips" {
  type        = string
  description = "FIPS Status"
  default     = "Disabled"
}

variable "worker_node_count" {
  type        = number
  description = <<EOF
  *** AZR_WORKER_NODE_COUNT ***
  The initial number and type of worker nodes to be created in 
  the cluster (1 VM created per node).
  EOF
  default     = 3
}

variable "master_vm_size" {
  type        = string
  description = <<EOF
  *** AZR_CONTROL_VMSIZE ***
  ARO Master Node Instance Size"
  EOF
  default     = "Standard_D8s_v5"
}

variable "worker_vm_size" {
  type        = string
  description = <<EOF
  *** AZR_WORKER_VMSIZE ***
  The initial number and type of worker nodes to be created in the cluster (1 VM created per node)
  EOF
  default     = "Standard_E4s_v5"
}

variable "worker_vm_disk_size" {
  type        = string
  description = <<EOF
  *** AZR_VM_DISK_SIZE ***
  ARO Worker VM Disk Size
  EOF
  default     = "500"
}

variable "aro_version" {
  type        = string
  description = <<EOF
  ARO version
  Default "4.12.33" - ARO_VERSION
  EOF
  default     = "4.12.34"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "sandbox"
    owner       = "your@email.address"
  }
}

variable "subscription_id" {
  type        = string
  description = <<EOF
  *** AZR_SUBSCRIPTION_ID ***
  A pre-existing AzureGov subscription where you want the ARO cluster to be installed
  EOF
  default     = "6cc4444k4k4k6d-34442-3344d8-98333-8a519e009009036"
}

variable "azr_vnet" {
  type        = string
  description = <<EOF
  *** AZR_VNET ***
  A pre-existing AzureGov /24 vNET within AZR_RESOURCE_GROUP_VNET containing the subnets for cluster networking
  EOF
  default     = "EKHO-GV-D-VNT-GF-01"
}

variable "azr_control_subnet" {
  type        = string
  description = <<EOF
  *** AZR_SUBNET_CONTROL ***
  A pre-existing AzureGov /26 subnet and associated NSG within AZR_VNET containing the ipaddress space for cluster control plane
  EOF
  default     = "EKHO-GV-D-SNT-GF-02"
}

variable "azr_worker_subnet" {
  type        = string
  description = <<EOF
  *** AZR_SUBNET_WORKER ***
  A pre-existing AzureGov /25 subnet within AZR_VNET containing the ipaddress space for cluster worker nodes
  EOF
  default     = "EKHO-GV-D-SNT-GF-01"
}

variable "azr_resource_group_vnet" {
  type        = string
  description = <<EOF
  *** AZR_RESOURCE_GROUP_VNET ***
  A pre-existing AzureGov RG within AZR_SUBSCRIPTION containing the VNET for cluster networking
  EOF
  default     = "EKHO-GV-D-RGP-VNT-01"
}

variable "outbound_type" {
  type        = string
  description = <<EOF
  Outbound Type - Loadbalancer or UserDefinedRouting
  Default "Loadbalancer"
  EOF
  default     = "UserDefinedRouting"
}

variable "akv_name" {
  type        = string
  description = <<EOF
  Azure Key Vault name
  EOF
  default     = "EKHO"
}

variable "akv_resource_group" {
  type        = string
  description = <<EOF
  Azure Key Vault Resource Group
  EOF
  default     = "azurestack"
}

variable "cluster_id" {
  type        = string
  description = <<EOF
  ID of ARO Cluster
  EOF
  default     = "1"
}

locals {
  sp_client_id     = "SP-${var.cluster_id}-ID"
  sp_client_secret = "SP-${var.cluster_id}-PASS"
  pull_secret      = var.pull_secret_name
}

variable "pull_secret_name" {
  type        = string
  description = <<EOF
  Pull Secret Name in AKV
  EOF
  default     = "pullSecret"
}




