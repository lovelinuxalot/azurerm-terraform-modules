# Create an Managed Azure Manged Virtual Network

This terraform module creates a Virtual Network which is managed by customer or someone else other than Terraform

## Usage in Terraform 0.13

```terraform
provider "azurerm" {
  version = ">=2.37"
  features {}
}

module "test-vnet-networking" {
  source = "modules/network/managed/vnet"
  location = "westus2"
  vnets = ""
}
```

## Input variables
|Name|Description|type|
|---|---|---|
|`resource_group_name`| Name of the resource group name |`string` |
|`location`| location to deploy the resource group | `string`|
|`tags`| Tags for the resource group | `map(string)`| 

## Output Variables
|Name|Description|type|
|---|---|---|
|`resource_group_name`| Name of the resource group name |`string` |
|`location`| location to deploy the resource group |`string`|
|`resource_group_id`| the ID of the resource group |`string`| 

## Testing Module

* Configure your Azure credentials as ENV variables
    * `ARM_CLIENT_ID`
    * `ARM_CLIENT_SECRET`
    * `ARM_SUBSCRIPTION_ID`
    * `ARM_TENANT_ID`
* Install Terraform and make sure it's on your PATH
* Configure your TerraTest Go test environment
* `cd tests/test`
* `go build terraform_resource_group_test.go`
* `go test -v -run TestTerraformAzureResourceGroup`


