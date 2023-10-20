# Using Terraform to build an ARO cluster

Azure Red Hat OpenShift (ARO) is a fully-managed turnkey application platform.

This is customized for ARO deployment with BYO-NSG & UDR in MAG. It also supports integration to Azure Key Vault.

## Setup

Using the code in the repo will require having the following tools installed:

- The Terraform CLI (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- The OC CLI (https://docs.openshift.com/container-platform/4.8/cli_reference/openshift_cli/getting-started-cli.html)

## Create the ARO cluster and required infrastructure

### Private ARO cluster with BYO-NGG, UDR and fetching secrets from Azure Key Vault

1. Modify the `variables.tf` to see the full list of variables that can be set.


   >NOTE: restrict_egress_traffic=true will secure ARO cluster by routing [Egress traffic through an Azure Firewall](https://learn.microsoft.com/en-us/azure/openshift/howto-restrict-egress).

   >NOTE2: Private Clusters can be created [without Public IP using the UserDefineRouting](https://learn.microsoft.com/en-us/azure/openshift/howto-create-private-cluster-4x#create-a-private-cluster-without-a-public-ip-address) flag in the outboundtype=UserDefineRouting variable. By default LoadBalancer is used for the egress.

2. Ensure that Azure Key Vault is updated with secrets whose keys are identified in the variables file - Pull Secret, sp_client_id & sp_client_secret

3. Install terraform dependencies & plugins
    ```bash
    terraform init -upgrade
    ```

4. Plan Terraform

   ```bash
   terraform apply aro.plan
   ```

5. Apply Configurations using Terraform

   ```bash
   terraform apply --auto-approve
   ```
## Test Connectivity

1. Get the ARO cluster's api server URL.

   ```bash
   ARO_URL=$(az aro show -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.apiserverProfile.url')
   echo $ARO_URL
   ```

1. Get the ARO cluster's Console URL

   ```bash
   CONSOLE_URL=$(az aro show -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.consoleProfile.url')
   echo $CONSOLE_URL
   ```

1. Get the ARO cluster's credentials.

   ```bash
   ARO_USERNAME=$(az aro list-credentials -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.kubeadminUsername')
   ARO_PASSWORD=$(az aro list-credentials -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.kubeadminPassword')
   echo $ARO_PASSWORD
   echo $ARO_USERNAME
   ```

## Cleanup

1. Delete Cluster and Resources

    ```bash
    terraform destroy -auto-approve
    rm -rf terraform.tfstate*
	rm -rf .terraform*
    ```
